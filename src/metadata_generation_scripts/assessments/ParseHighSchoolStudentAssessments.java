import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Scanner;

// class ParseHighSchoolStudentAssessments
//
// The script generates a <student_id>_assessments.txt metadata file for each
// student who auditioned for either the concert band or the symphonic band.
//
// This script DOES NOT PARSE THE XLSX FILE. Instead, parses two text files, 
// "Concert_Band_Scores.txt" and "Symphonic_Band_Scores.txt", that was generated 
// by copy-pasting from the the xlsx files. The student assessments text files were 
// created from the 'Raw Scores' view of '.xlsx' by copying columns B-F of the xlsx
// file (Student, Instrument, CategoryGroup, Category, and Score).
//
// The first line of each student_assessments.txt is a comment that explains the
// format of the file. You can read that comment to understand the format. That
// comment is in the method writeStudentsToFiles().
//
// Authored by Chris Laguna
public class ParseHighSchoolStudentAssessments {

	// All existing students.
	private static HashMap<Integer, HighSchoolStudentAssessments> students;

  /////////////////////////// Methods ///////////////////////////

  // Initialize the students hashmap.
  public static void initMap() {
    students = new HashMap<Integer, HighSchoolStudentAssessments>();
  }

  // Returns the HighSchoolStudentAssessments object whose id == |student_id|.
  public static HighSchoolStudentAssessments getStudent(int student_id) {
    // Create student if it doesn't already exist.
    if (!students.containsKey(student_id)) {
    	students.put(student_id, new HighSchoolStudentAssessments(student_id));
    }
    return students.get(student_id);
  }

  // Parses a line of the students_asssessments text file. Each line corresponds
  // to a single assessment.
	public static void parseLine(String line) {
	  Scanner scanner = new Scanner(line);
	  scanner.useDelimiter("\t");
 
    // Make sure line exists. Then, assume it follows the correct format 
    // (five tab-delimited strings).
    if (scanner.hasNext()) {
	    String student_id_string = scanner.next();

	    // Ignore instrument information.
	    String instrument = scanner.next();  
	    String assessment = scanner.next();
	    assessment = assessment + scanner.next();

	    // Remove all non-alpha letters from string to remove ambiguity.
	    assessment = assessment.replaceAll("[^a-zA-Z]", "");
      String value_string = scanner.next();

      // Convert from string to ints.
      int student_id = Integer.parseInt(student_id_string);
      int value = Integer.parseInt(value_string);

      HighSchoolStudentAssessments student = ParseHighSchoolStudentAssessments.getStudent(student_id);
      student.addAssessment(assessment, value);
	  }
	}
	  

  // Add all assessments in the given text file to students.
  public static void parseAssessmentFile(String filename) throws FileNotFoundException {
  File file = new File(filename);
  Scanner input = new Scanner(file);

    // Parse line by line.
  while(input.hasNextLine()) {
	String next_line = input.nextLine();
	ParseHighSchoolStudentAssessments.parseLine(next_line);
  }
  }

  // Writes the student_assessments files. 
  public static void writeStudentsToFiles(int which_band) 
      throws FileNotFoundException, UnsupportedEncodingException {

    String file_path = "";

    // Concert Band
    if(which_band == 0) {
      file_path = "../../FBA2013/concertbandscores/";
    }
    // Symphonic Band
    else if (which_band == 1) {
      file_path = "../../FBA2013/symphonicbandscores/";
    }

    String comment_string = "";

    comment_string += "// assessments: range 0.00 (poor)...1.00 (excellent), rounded to 2 decimal places; " +
                      "-1.0 indicates no assessment. rows -> segments, columns -> categories. ";
    comment_string += 
                   "rows: lyricalEtude, technicalEtude, scalesChromatic, scalesMajor, sightReading, " +
                   "malletEtude, snareEtude, timpaniEtude, readingMallet, readingSnare. " + 
                   "columns: articulation, artistry, musicalityTempoStyle, noteAccuracy, " +
                   "rhythmicAccuracy, toneQuality, articulationStyle, musicalityPhrasingStyle, " +
                   "noteAccuracyConsistency, tempoConsistency, " +
                   "Ab, A, Bb, B, C, Db, D, Eb, E, F, Gb, G, chromatic, musicalityStyle, " +
                   "noteAccuracyTone, rhythmicAccuracyArticulation." +
                   "\n";
    // Add one student string (aka one line) at a time.
    for (HighSchoolStudentAssessments student : ParseHighSchoolStudentAssessments.students.values()) {
      String file_string = comment_string + student.toString();

/*   Only necessary if you need to recreate the file strucutre.
 
     // Check if student directory exists. If not, create it.
     File student_dir = new File(file_path + Integer.toString(student.getID()));
 
     if (!student_dir.exists()) {
       System.out.println("Creating directory: " + Integer.toString(student.getID()) + "...");
       boolean result = false;
 
       try{
           student_dir.mkdir();
           result = true;
        } catch(SecurityException se){
        }        
        if(result) {    
          System.out.println("Directory created.");  
        }
     }
*/
     
      PrintWriter writer = new PrintWriter(file_path + Integer.toString(student.getID()) + "/" + Integer.toString(student.getID()) + "_assessments.txt", "UTF-8");
      writer.println(file_string);
      writer.close();
    }

  }

  // The script starts here.
	public static void main(String[] args) 
        throws FileNotFoundException, UnsupportedEncodingException {
	  ParseHighSchoolStudentAssessments.initMap();

    // Retrieve assessment max values from file.
    MaxAssessments max_assessments = new MaxAssessments();
    max_assessments.parseMaxAssessmentFile("txt_files/High_School_Bands_Max_Scores.txt");

    // Retrieve student assessments from Concert Band.
    ParseHighSchoolStudentAssessments.parseAssessmentFile("txt_files/Concert_Band_Scores.txt");

    // Normalize student assessments using max assessment values.
    for (HighSchoolStudentAssessments student : ParseHighSchoolStudentAssessments.students.values()) {
      student.normalizeFromMax(max_assessments);
    }

    // Write normalized student assessments to file.
    ParseHighSchoolStudentAssessments.writeStudentsToFiles(0);

    // Clear out the concert band students before dealing with the Symphonic
    // Band students.
    students.clear();

    // Retrieve student assessments from Symphonic Band.
    ParseHighSchoolStudentAssessments.parseAssessmentFile("txt_files/Symphonic_Band_Scores.txt");

    // Normalize student assessments using max assessment values.
    for (HighSchoolStudentAssessments student : ParseHighSchoolStudentAssessments.students.values()) {
      student.normalizeFromMax(max_assessments);
    }

    // Write normalized student assessments to file.
    ParseHighSchoolStudentAssessments.writeStudentsToFiles(1);
	}
}