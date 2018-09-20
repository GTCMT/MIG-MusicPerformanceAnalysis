// class MiddleSchoolStudentAssessments
//
// This class represents a music student in the FBA database whose auditions
// have been assessed by judges. Unordered assessments are read from a text file,
// stored in a MiddleSchoolStudentAssessments class, and printed out in a specified order and
// format (See ParseMiddleSchoolStudentAssessments.java for the format).
//
// Authored by Chris Laguna
public class MiddleSchoolStudentAssessments {

  ////////////////////////// Fields ////////////////////////
  private int student_id;

  // Assessments
  private float lyrical_etude_musicality_tempo_style;
  private float lyrical_etude_tone_quality;
  private float lyrical_etude_note_accuracy;
  private float lyrical_etude_rhythmic_accuracy;
  private float lyrical_etude_artistry;

  private float technical_etude_musicality_tempo_style;
  private float technical_etude_tone_quality;
  private float technical_etude_note_accuracy;
  private float technical_etude_rhythmic_accuracy;
  private float technical_etude_articulation;

  private float sight_reading_musicality_tempo_style;
  private float sight_reading_tone_quality;
  private float sight_reading_note_accuracy;
  private float sight_reading_rhythmic_accuracy;
  private float sight_reading_artistry;

  private float scales_chromatic;
  private float scales_g;
  private float scales_c;
  private float scales_f;
  private float scales_bb;
  private float scales_eb;
  private float scales_ab;
  private float scales_db;
  private float scales_note_accuracy_consistency;
  private float scales_tone_quality;
  private float scales_musicality_tempo_style;
  private float scales_articulation_style;

  private float mallet_etude_musicality_tempo_style;
  private float mallet_etude_note_accuracy;
  private float mallet_etude_rhythmic_accuracy;

  private float reading_mallet_musicality_style;
  private float reading_mallet_note_accuracy_tone;
  private float reading_mallet_rhythmic_accuracy_articulation;

  private float snare_etude_musicality_tempo_style;
  private float snare_etude_note_accuracy;
  private float snare_etude_rhythmic_accuracy;

  private float reading_snare_musicality_style;
  private float reading_snare_note_accuracy_tone;
  private float reading_snare_rhythmic_accuracy_articulation;

  private float timpani_etude_musicality_tempo_style;
  private float timpani_etude_note_accuracy;
  private float timpani_etude_rhythmic_accuracy;
  
  private float scales_musicality_phrasing_style;    
  private float scales_note_accuracy;
  private float scales_tempo_consistency;

  /////////////////////////// Constructors /////////////////////////////

  // Student is constructed having no assessments...assessments are added later.
  public MiddleSchoolStudentAssessments(int s_id) {
    student_id = s_id;
    lyrical_etude_musicality_tempo_style = -1.f;
    lyrical_etude_tone_quality = -1.f;
    lyrical_etude_note_accuracy = -1.f;
    lyrical_etude_rhythmic_accuracy = -1.f;
    lyrical_etude_artistry = -1.f;

    technical_etude_musicality_tempo_style = -1.f;
    technical_etude_tone_quality = -1.f;
    technical_etude_note_accuracy = -1.f;
    technical_etude_rhythmic_accuracy = -1.f;
    technical_etude_articulation = -1.f;

    sight_reading_musicality_tempo_style = -1.f;
    sight_reading_tone_quality = -1.f;
    sight_reading_note_accuracy = -1.f;
    sight_reading_rhythmic_accuracy = -1.f;
    sight_reading_artistry = -1.f;

    scales_chromatic = -1.f;
    scales_g = -1.f;
    scales_c = -1.f;
    scales_f = -1.f;
    scales_bb = -1.f;
    scales_eb = -1.f;
    scales_ab = -1.f;
    scales_db = -1.f;
    scales_note_accuracy_consistency = -1.f;
    scales_tone_quality = -1.f;
    scales_musicality_tempo_style = -1.f;
    scales_articulation_style = -1.f;

    mallet_etude_musicality_tempo_style = -1.f;
    mallet_etude_note_accuracy = -1.f;
    mallet_etude_rhythmic_accuracy = -1.f;

    reading_mallet_musicality_style = -1.f;
    reading_mallet_note_accuracy_tone = -1.f;
    reading_mallet_rhythmic_accuracy_articulation = -1.f;

    snare_etude_musicality_tempo_style = -1.f;
    snare_etude_note_accuracy = -1.f;
    snare_etude_rhythmic_accuracy = -1.f;

    reading_snare_musicality_style = -1.f;
    reading_snare_note_accuracy_tone = -1.f;
    reading_snare_rhythmic_accuracy_articulation = -1.f;

    timpani_etude_musicality_tempo_style = -1.f;
    timpani_etude_note_accuracy = -1.f;
    timpani_etude_rhythmic_accuracy = -1.f;
  
    scales_musicality_phrasing_style = -1.f;    
    scales_note_accuracy = -1.f;
    scales_tempo_consistency = -1.f;
  }

  /////////////////////////// Methods /////////////////////////////

  public int getID() {
    return student_id;
  }
	
  // This one function sets a single assessment to |val|. The Assessment
  // to change depends on |assessment|, where all non-alpha charachters have
  // been removed from the string to deal with differing naming conventions that
  // occur throughout the metdata xml files.
	public void addAssessment(String assessment, float val) { 
    if (assessment.equals("LyricalEtudeMusicalityTempoStyle") ) {
      this.lyrical_etude_musicality_tempo_style = val;
    }
    else if (assessment.equals("LyricalEtudeToneQuality")) {
      this.lyrical_etude_tone_quality = val;
    }
    else if (assessment.equals("LyricalEtudeNoteAccuracy")) {
      this.lyrical_etude_note_accuracy = val;
    }
    else if (assessment.equals("LyricalEtudeRhythmicAccuracy")) {
      this.lyrical_etude_rhythmic_accuracy = val;
    }
    else if (assessment.equals("LyricalEtudeArtistry")) {
      this.lyrical_etude_artistry = val;
    }

    else if (assessment.equals("MalletEtudeMusicalityTempoStyle")) {
      this.mallet_etude_musicality_tempo_style = val;
    }
    else if (assessment.equals("MalletEtudeNoteAccuracy")) {
      this.mallet_etude_note_accuracy = val;
    }
    else if (assessment.equals("MalletEtudeRhythmicAccuracy")) {
      this.mallet_etude_rhythmic_accuracy = val;
    }

    else if (assessment.equals("ReadingMalletNoteAccuracyTone")) {
      this.reading_mallet_note_accuracy_tone = val;
    }
    else if (assessment.equals("ReadingMalletRhythmicAccuracyArticulation")) {
      this.reading_mallet_rhythmic_accuracy_articulation = val;
    }
    else if (assessment.equals("ReadingMalletMusicalityStyle")) {
      this.reading_mallet_musicality_style = val;
    }

    else if (assessment.equals("ReadingSnareNoteAccuracyTone")) {
      this.reading_snare_note_accuracy_tone = val;
    }
    else if (assessment.equals("ReadingSnareRhythmicAccuracyArticulation")) {
      this.reading_snare_rhythmic_accuracy_articulation = val;
    }
    else if (assessment.equals("ReadingSnareMusicalityStyle")) {
      this.reading_snare_musicality_style = val;
    }

    else if (assessment.equals("ScalesChromatic")) {
      this.scales_chromatic = val;
    }
    else if (assessment.equals("ScalesNoteAccuracy")) {
      this.scales_note_accuracy = val;
    }
    else if (assessment.equals("ScalesTempoConsistency")) {
      this.scales_tempo_consistency = val;
    }
    else if (assessment.equals("ScalesMusicalityPhrasingStyle")) {
      this.scales_musicality_phrasing_style = val;
    }
    else if (assessment.equals("ScalesG")) {
      this.scales_g = val;
    }
    else if (assessment.equals("ScalesC")) {
      this.scales_c = val;
    }
    else if (assessment.equals("ScalesF")) {
      this.scales_f = val;
    }
    else if (assessment.equals("ScalesBb")) {
      this.scales_bb = val;
    }
    else if (assessment.equals("ScalesEb")) {
      this.scales_eb = val;
    }
    else if (assessment.equals("ScalesAb")) {
      this.scales_ab = val;
    }
    else if (assessment.equals("ScalesDb")) {
      this.scales_db = val;
    }
    else if (assessment.equals("ScalesNoteAccuracyConsistency")) {
      this.scales_note_accuracy_consistency = val;
    }
    else if (assessment.equals("ScalesToneQuality")) {
      this.scales_tone_quality = val;
    }
    else if (assessment.equals("ScalesMusicalityTempoStyle")) {
      this.scales_musicality_tempo_style = val;
    }
    else if (assessment.equals("ScalesArticulationStyle")) {
      this.scales_articulation_style = val;
    }

    else if (assessment.equals("SightReadingNoteAccuracy")) {
      this.sight_reading_note_accuracy = val;
    }
    else if (assessment.equals("SightReadingRhythmicAccuracy")) {
      this.sight_reading_rhythmic_accuracy = val;
    }
    else if (assessment.equals("SightReadingMusicalityTempoStyle")) {
      this.sight_reading_musicality_tempo_style = val;
    }
    else if (assessment.equals("SightReadingToneQuality")) {
      this.sight_reading_tone_quality = val;
    }
    else if (assessment.equals("SightReadingArtistry")) {
      this.sight_reading_artistry = val;
    }

    else if (assessment.equals("SnareEtudeMusicalityTempoStyle")) {
      this.snare_etude_musicality_tempo_style = val;
    }
    else if (assessment.equals("SnareEtudeNoteAccuracy")) {
      this.snare_etude_note_accuracy = val;
    }
    else if (assessment.equals("SnareEtudeRhythmicAccuracy")) {
      this.snare_etude_rhythmic_accuracy = val;
    }

    else if (assessment.equals("TechnicalEtudeMusicalityTempoStyle")) {
      this.technical_etude_musicality_tempo_style = val;
    }
    else if (assessment.equals("TechnicalEtudeToneQuality")) {
      this.technical_etude_tone_quality = val;
    }
    else if (assessment.equals("TechnicalEtudeNoteAccuracy")) {
      this.technical_etude_note_accuracy = val;
    }
    else if (assessment.equals("TechnicalEtudeRhythmicAccuracy")) {
      this.technical_etude_rhythmic_accuracy = val;
    }
    else if (assessment.equals("TechnicalEtudeArticulation")) {
      this.technical_etude_articulation = val;
    }

    else if (assessment.equals("TimpaniEtudeMusicalityTempoStyle")) {
      this.timpani_etude_musicality_tempo_style = val;
    }
    else if (assessment.equals("TimpaniEtudeNoteAccuracy")) {
      this.timpani_etude_note_accuracy = val;
    }
    else if (assessment.equals("TimpaniEtudeRhythmicAccuracy")) {
      this.timpani_etude_rhythmic_accuracy = val;
    }

    else {
      System.out.println("Couldn't find assessment for: " + assessment);
    }
  }

  // Normalize all assessment values at once. All values range from 0 to 
  // |max|, inclusive. See MaxAssessments.java for more information about
  // max assessment values.
  public void normalizeFromMax(MaxAssessments maxes) {
    if (this.lyrical_etude_musicality_tempo_style != -1.f) {
      this.lyrical_etude_musicality_tempo_style /= maxes.lyrical_etude_musicality_tempo_style;
    }
    if (this.lyrical_etude_tone_quality != -1.f) {
      this.lyrical_etude_tone_quality /= maxes.lyrical_etude_tone_quality;
    }
    if (this.lyrical_etude_note_accuracy != -1.f) {
      this.lyrical_etude_note_accuracy /= maxes.lyrical_etude_note_accuracy;
    }
    if (this.lyrical_etude_rhythmic_accuracy != -1.f) {
      this.lyrical_etude_rhythmic_accuracy /= maxes.lyrical_etude_rhythmic_accuracy;
    }
    if (this.lyrical_etude_artistry != -1.f) {
      this.lyrical_etude_artistry /= maxes.lyrical_etude_artistry;
    }  

    if (this.mallet_etude_musicality_tempo_style != -1.f) {
      this.mallet_etude_musicality_tempo_style /= maxes.mallet_etude_musicality_tempo_style;
    }
    if (this.mallet_etude_note_accuracy != -1.f) {
      this.mallet_etude_note_accuracy /= maxes.mallet_etude_note_accuracy;
    }
    if (this.mallet_etude_rhythmic_accuracy != -1.f) {
      this.mallet_etude_rhythmic_accuracy /= maxes.mallet_etude_rhythmic_accuracy;
    }    

    if (this.reading_mallet_note_accuracy_tone != -1.f) {
      this.reading_mallet_note_accuracy_tone /= maxes.reading_mallet_note_accuracy_tone;
    }
    if (this.reading_mallet_rhythmic_accuracy_articulation != -1.f) {
      this.reading_mallet_rhythmic_accuracy_articulation /= maxes.reading_mallet_rhythmic_accuracy_articulation;
    }
    if (this.reading_mallet_musicality_style != -1.f) {
      this.reading_mallet_musicality_style /= maxes.reading_mallet_musicality_style;
    }    

    if (this.reading_snare_note_accuracy_tone != -1.f) {
      this.reading_snare_note_accuracy_tone /= maxes.reading_snare_note_accuracy_tone;
    }
    if (this.reading_snare_rhythmic_accuracy_articulation != -1.f) {
      this.reading_snare_rhythmic_accuracy_articulation /= maxes.reading_snare_rhythmic_accuracy_articulation;
    }
    if (this.reading_snare_musicality_style != -1.f) {
      this.reading_snare_musicality_style /= maxes.reading_snare_musicality_style;
    }      

    if (this.scales_chromatic != -1.f) {
      this.scales_chromatic /= maxes.scales_chromatic;
    }
    if (this.scales_note_accuracy != -1.f) {
      this.scales_note_accuracy /= maxes.scales_note_accuracy;
    }
    if (this.scales_tempo_consistency != -1.f) {
      this.scales_tempo_consistency /= maxes.scales_tempo_consistency;
    }    
    if (this.scales_musicality_phrasing_style != -1.f) {
      this.scales_musicality_phrasing_style /= maxes.scales_musicality_phrasing_style;
    }      
    if (this.scales_g != -1.f) {
      this.scales_g /= maxes.scales_g;
    }
    if (this.scales_c != -1.f) {
      this.scales_c /= maxes.scales_c;
    }
    if (this.scales_f != -1.f) {
      this.scales_f /= maxes.scales_f;
    }    
    if (this.scales_bb != -1.f) {
      this.scales_bb /= maxes.scales_bb;
    }
    if (this.scales_eb != -1.f) {
      this.scales_eb /= maxes.scales_eb;
    }
    if (this.scales_ab != -1.f) {
      this.scales_ab /= maxes.scales_ab;
    }    
    if (this.scales_db != -1.f) {
      this.scales_db /= maxes.scales_db;
    }
    if (this.scales_note_accuracy_consistency != -1.f) {
      this.scales_note_accuracy_consistency /= maxes.scales_note_accuracy_consistency;
    }
    if (this.scales_tone_quality != -1.f) {
      this.scales_tone_quality /= maxes.scales_tone_quality;
    }  
    if (this.scales_musicality_tempo_style != -1.f) {
      this.scales_musicality_tempo_style /= maxes.scales_musicality_tempo_style;
    }
    if (this.scales_articulation_style != -1.f) {
      this.scales_articulation_style /= maxes.scales_articulation_style;
    }     

    if (this.sight_reading_note_accuracy != -1.f) {
      this.sight_reading_note_accuracy /= maxes.sight_reading_note_accuracy;
    }
    if (this.sight_reading_rhythmic_accuracy != -1.f) {
      this.sight_reading_rhythmic_accuracy /= maxes.sight_reading_rhythmic_accuracy;
    }
    if (this.sight_reading_musicality_tempo_style != -1.f) {
      this.sight_reading_musicality_tempo_style /= maxes.sight_reading_musicality_tempo_style;
    }  
    if (this.sight_reading_tone_quality != -1.f) {
      this.sight_reading_tone_quality /= maxes.sight_reading_tone_quality;
    }
    if (this.sight_reading_artistry != -1.f) {
      this.sight_reading_artistry /= maxes.sight_reading_artistry;
    }  

    if (this.snare_etude_musicality_tempo_style != -1.f) {
      this.snare_etude_musicality_tempo_style /= maxes.snare_etude_musicality_tempo_style;
    }  
    if (this.snare_etude_note_accuracy != -1.f) {
      this.snare_etude_note_accuracy /= maxes.snare_etude_note_accuracy;
    }
    if (this.snare_etude_rhythmic_accuracy != -1.f) {
      this.snare_etude_rhythmic_accuracy /= maxes.snare_etude_rhythmic_accuracy;
    }  

    if (this.technical_etude_musicality_tempo_style != -1.f) {
      this.technical_etude_musicality_tempo_style /= maxes.technical_etude_musicality_tempo_style;
    }
    if (this.technical_etude_tone_quality != -1.f) {
      this.technical_etude_tone_quality /= maxes.technical_etude_tone_quality;
    }
    if (this.technical_etude_note_accuracy != -1.f) {
      this.technical_etude_note_accuracy /= maxes.technical_etude_note_accuracy;
    }  
    if (this.technical_etude_rhythmic_accuracy != -1.f) {
      this.technical_etude_rhythmic_accuracy /= maxes.technical_etude_rhythmic_accuracy;
    }
    if (this.technical_etude_articulation != -1.f) {
      this.technical_etude_articulation /= maxes.technical_etude_articulation;
    }

    if (this.timpani_etude_musicality_tempo_style != -1.f) {
      this.timpani_etude_musicality_tempo_style /= maxes.timpani_etude_musicality_tempo_style;
    }  
    if (this.timpani_etude_note_accuracy != -1.f) {
      this.timpani_etude_note_accuracy /= maxes.timpani_etude_note_accuracy;
    }
    if (this.timpani_etude_rhythmic_accuracy != -1.f) {
      this.timpani_etude_rhythmic_accuracy /= maxes.timpani_etude_rhythmic_accuracy;
    }
  }

  // The assessments are output to a string in a logical ordering and format
  // (See ParseMiddleSchoolStudentAssessments for information on the format).
  public String toString() {
    return 
        // Only one decimal place for -1 because "-" takes up an extra character.
        "-1.0" +
        "\t" + (this.lyrical_etude_artistry < 0 ? "-1.0" : String.format("%.2f", this.lyrical_etude_artistry)) + 
        "\t" + (this.lyrical_etude_musicality_tempo_style < 0 ? "-1.0" : String.format("%.2f", this.lyrical_etude_musicality_tempo_style)) + 
        "\t" + (this.lyrical_etude_note_accuracy < 0 ? "-1.0" : String.format("%.2f", this.lyrical_etude_note_accuracy)) +
        "\t" + (this.lyrical_etude_rhythmic_accuracy < 0 ? "-1.0" : String.format("%.2f", this.lyrical_etude_rhythmic_accuracy)) + 
        "\t" + (this.lyrical_etude_tone_quality < 0 ? "-1.0" : String.format("%.2f", this.lyrical_etude_tone_quality)) + 
        "\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" + 

        "\n" + 

               (this.technical_etude_articulation < 0 ? "-1.0" : String.format("%.2f", this.technical_etude_articulation)) +
        "\t-1.0" +
        "\t" + (this.technical_etude_musicality_tempo_style < 0 ? "-1.0" : String.format("%.2f", this.technical_etude_musicality_tempo_style)) +
        "\t" + (this.technical_etude_note_accuracy < 0 ? "-1.0" : String.format("%.2f", this.technical_etude_note_accuracy)) +
        "\t" + (this.technical_etude_rhythmic_accuracy < 0 ? "-1.0" : String.format("%.2f", this.technical_etude_rhythmic_accuracy)) +
        "\t" + (this.technical_etude_tone_quality < 0 ? "-1.0" : String.format("%.2f", this.technical_etude_tone_quality)) +
        "\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" + 

        "\n" + 

        "-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" +
        "\t" + (this.scales_chromatic < 0 ? "-1.0" : String.format("%.2f", this.scales_chromatic)) +
        "\t-1.0\t-1.0\t-1.0" + 
 
        "\n" +

        "-1.0\t-1.0" +
        "\t" + (this.scales_musicality_tempo_style < 0 ? "-1.0" : String.format("%.2f", this.scales_musicality_tempo_style)) +
        "\t" + (this.scales_note_accuracy < 0 ? "-1.0" : String.format("%.2f", this.scales_note_accuracy)) +
        "\t-1.0" +
        "\t" + (this.scales_tone_quality < 0 ? "-1.0" : String.format("%.2f", this.scales_tone_quality)) +
        "\t" + (this.scales_articulation_style < 0 ? "-1.0" : String.format("%.2f", this.scales_articulation_style)) +
        "\t" + (this.scales_musicality_phrasing_style < 0 ? "-1.0" : String.format("%.2f", this.scales_musicality_phrasing_style)) +
        "\t" + (this.scales_note_accuracy_consistency < 0 ? "-1.0" : String.format("%.2f", this.scales_note_accuracy_consistency)) +
        "\t" + (this.scales_tempo_consistency < 0 ? "-1.0" : String.format("%.2f", this.scales_tempo_consistency)) +
        "\t" + (this.scales_ab < 0 ? "-1.0" : String.format("%.2f", this.scales_ab)) +
        "\t-1.0" +
        "\t" + (this.scales_bb < 0 ? "-1.0" : String.format("%.2f", this.scales_bb)) +
        "\t-1.0" +
        "\t" + (this.scales_c < 0 ? "-1.0" : String.format("%.2f", this.scales_c)) +
        "\t" + (this.scales_db < 0 ? "-1.0" : String.format("%.2f", this.scales_db)) +
        "\t-1.0" +
        "\t" + (this.scales_eb < 0 ? "-1.0" : String.format("%.2f", this.scales_eb)) +
        "\t-1.0" +
        "\t" + (this.scales_f < 0 ? "-1.0" : String.format("%.2f", this.scales_f)) +
        "\t-1.0" +
        "\t" + (this.scales_g < 0 ? "-1.0" : String.format("%.2f", this.scales_g)) +
        "\t-1.0\t-1.0\t-1.0\t-1.0" +

        "\n" +

        "-1.0" +
        "\t" + (this.sight_reading_artistry < 0 ? "-1.0" : String.format("%.2f", this.sight_reading_artistry)) +
        "\t" + (this.sight_reading_musicality_tempo_style < 0 ? "-1.0" : String.format("%.2f", this.sight_reading_musicality_tempo_style)) +
        "\t" + (this.sight_reading_note_accuracy < 0 ? "-1.0" : String.format("%.2f", this.sight_reading_note_accuracy)) +
        "\t" + (this.sight_reading_rhythmic_accuracy < 0 ? "-1.0" : String.format("%.2f", this.sight_reading_rhythmic_accuracy)) +
        "\t" + (this.sight_reading_tone_quality < 0 ? "-1.0" : String.format("%.2f", this.sight_reading_tone_quality)) +
        "\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" + 

        "\n" + 

        "-1.0\t-1.0" +
        "\t" + (this.mallet_etude_musicality_tempo_style < 0 ? "-1.0" : String.format("%.2f", this.mallet_etude_musicality_tempo_style)) +
        "\t" + (this.mallet_etude_note_accuracy < 0 ? "-1.0" : String.format("%.2f", this.mallet_etude_note_accuracy)) +
        "\t" + (this.mallet_etude_rhythmic_accuracy < 0 ? "-1.0" : String.format("%.2f", this.mallet_etude_rhythmic_accuracy)) +
        "\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" + 

        "\n" + 

        "-1.0\t-1.0" +
        "\t" + (this.snare_etude_musicality_tempo_style < 0 ? "-1.0" : String.format("%.2f", this.snare_etude_musicality_tempo_style)) +
        "\t" + (this.snare_etude_note_accuracy < 0 ? "-1.0" : String.format("%.2f", this.snare_etude_note_accuracy)) +
        "\t" + (this.snare_etude_rhythmic_accuracy < 0 ? "-1.0" : String.format("%.2f", this.snare_etude_rhythmic_accuracy)) +
        "\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" + 

        "\n" + 

        "-1.0\t-1.0" +
        "\t" + (this.timpani_etude_musicality_tempo_style < 0 ? "-1.0" : String.format("%.2f", this.timpani_etude_musicality_tempo_style)) +
        "\t" + (this.timpani_etude_note_accuracy < 0 ? "-1.0" : String.format("%.2f", this.timpani_etude_note_accuracy)) +
        "\t" + (this.timpani_etude_rhythmic_accuracy < 0 ? "-1.0" : String.format("%.2f", this.timpani_etude_rhythmic_accuracy)) +
        "\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" + 

        "\n" + 

        "-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" +
        "\t" + (this.reading_mallet_musicality_style < 0 ? "-1.0" : String.format("%.2f", this.reading_mallet_musicality_style)) +
        "\t" + (this.reading_mallet_note_accuracy_tone < 0 ? "-1.0" : String.format("%.2f", this.reading_mallet_note_accuracy_tone)) +
        "\t" + (this.reading_mallet_rhythmic_accuracy_articulation < 0 ? "-1.0" : String.format("%.2f", this.reading_mallet_rhythmic_accuracy_articulation)) +

        "\n" + 

        "-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0\t-1.0" +
        "\t" + (this.reading_snare_musicality_style < 0 ? "-1.0" : String.format("%.2f", this.reading_snare_musicality_style)) +
        "\t" + (this.reading_snare_note_accuracy_tone < 0 ? "-1.0" : String.format("%.2f", this.reading_snare_note_accuracy_tone)) +
        "\t" + (this.reading_snare_rhythmic_accuracy_articulation < 0 ? "-1.0" : String.format("%.2f", this.reading_snare_rhythmic_accuracy_articulation)) +

        "\n";
  }
}
