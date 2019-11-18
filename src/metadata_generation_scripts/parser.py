import sys
import os
import csv
import xlrd
from string import ascii_letters
import pandas as pd
import pickle

global max_scores_file

path = '../../../MIG-FbaData'

def extract_alpha(astr):
	return "".join([char.lower() for char in astr if char in (ascii_letters)])

def standardize(astr):
	assessment = extract_alpha(astr)
	if assessment == "LyricalEtudeMusicallityTempoStyle".lower():
		assessment = 'lyrical_etude_musicality_tempo_style'
	elif assessment == "LyricalEtudeToneQuality".lower():
		assessment = 'lyrical_etude_tone_quality'
	elif assessment == "LyricalEtudeNoteAccuracy".lower():
		assessment = 'lyrical_etude_note_accuracy'
	elif assessment == "LyricalEtudeRhythmicAccuracy".lower():
		assessment = 'lyrical_etude_rhythmic_accuracy'
	elif assessment == "LyricalEtudeArtistry".lower():
		assessment = 'lyrical_etude_artistry'

	elif assessment == "MalletEtudeMusicalityTempoStyle".lower():
		assessment = 'mallet_etude_musicality_tempo_style'
	elif "MalletEtudeNoteAccuracy".lower() in assessment:
		assessment = 'mallet_etude_note_accuracy'
	elif assessment == "MalletEtudeRhythmicAccuracy".lower():
		assessment = 'mallet_etude_rhythmic_accuracy'

	elif assessment == "ReadingMalletMusicalityStyle".lower():
		assessment = 'reading_mallet_musicality_style'
	elif assessment == "ReadingMalletMusicalityTempoStyle".lower():
		assessment = 'reading_mallet_musicality_tempo_style'
	elif assessment == "ReadingMalletNoteAccuracyTone".lower():
		assessment = 'reading_mallet_note_accuracy_tone'
	elif assessment == "ReadingMalletRhythmicAccuracyArticulation".lower() or assessment == "ReadingMalletRhythmicAccuracy".lower():
		assessment = 'reading_mallet_rhythmic_accuracy_articulation'

	elif assessment == "ReadingTimpaniRhythmicAccuracyArticulation".lower():
		assessment = 'reading_timpani_rhythmic_accuracy_articulation'
	elif assessment == "ReadingTimpaniMusicalityStyle".lower():
		assessment = 'reading_timpani_musicality_style'
	elif assessment == "ReadingTimpaniNoteAccuracy".lower():
		assessment = 'reading_timpani_note_accuracy'

	elif assessment == "ReadingSnareNoteAccuracyTone".lower():
		assessment = 'reading_snare_note_accuracy_tone'
	elif assessment == "ReadingSnareRhythmicAccuracyArticulation".lower() or assessment == "ReadingSnareRhythmicAccuracy".lower():
		assessment = 'reading_snare_rhythmic_accuracy_articulation'
	elif assessment == "ReadingSnareMusicalityStyle".lower():
		assessment = 'reading_snare_musicality_style'
	elif assessment == "ReadingSnareMusicalityTempoStyle".lower():
		assessment = 'reading_snare_musicality_tempo_style'
	elif assessment == "ReadingSnareMusicalityStyle".lower():
		assessment = 'reading_snare_musicality_style'

	elif assessment == "ScalesChromatic".lower() or assessment == 'ChromaticScaleChromaticScale'.lower() or assessment == 'ChromaticScaleChromatic'.lower():
		assessment = 'scales_chromatic'
	elif "ScalesNoteAccuracy".lower() in assessment:
		assessment = 'scales_note_accuracy'
	elif "ScalesTempoConsistency".lower() in  assessment:
		assessment = 'scales_tempo_consistency'
	elif "ScalesMusicalityPhrasingStyle".lower() in assessment:
		assessment = 'scales_musicality_phrasing_style'
	elif assessment == "ScalesG".lower() or assessment == "MajorScalesG".lower():
		assessment = 'scales_g'
	elif assessment == "ScalesGb".lower() or assessment == "MajorScalesGb".lower():
		assessment = 'scales_gb'
	elif assessment == "ScalesC".lower() or assessment == "MajorScalesC".lower():
		assessment = 'scales_c'
	elif assessment == "ScalesF".lower() or assessment == "MajorScalesF".lower():
		assessment = 'scales_f'
	elif assessment == "ScalesBb".lower() or assessment == "MajorScalesBb".lower():
		assessment = 'scales_bb'
	elif assessment == "ScalesEb".lower() or assessment == "MajorScalesEb".lower():
		assessment = 'scales_eb'
	elif assessment == "ScalesB".lower() or assessment == "MajorScalesB".lower():
		assessment = 'scales_b'
	elif assessment == "ScalesD".lower() or assessment == "MajorScalesD".lower():
		assessment = 'scales_d'
	elif assessment == "ScalesE".lower() or assessment == "MajorScalesE".lower():
		assessment = 'scales_e'
	elif assessment == "ScalesAb".lower() or assessment == "MajorScalesAb".lower():
		assessment = 'scales_ab'
	elif assessment == "ScalesA".lower() or assessment == "MajorScalesA".lower():
		assessment = 'scales_a'
	elif assessment == "ScalesDb".lower() or assessment == "MajorScalesDb".lower():
		assessment = 'scales_db'
	elif assessment == "ScalesToneQuality".lower():
		assessment = 'scales_tone_quality'
	elif assessment == "ScalesMusicalityTempoStyle".lower():
		assessment = 'scales_musicality_tempo_style'
	elif assessment == "ScalesArticulationStyle".lower():
		assessment = 'scales_articulation_style'

	elif assessment == "SightReadingNoteAccuracy".lower():
		assessment = 'sight_reading_note_accuracy'
	elif assessment == "SightReadingRhythmicAccuracy".lower():
		assessment = 'sight_reading_rhythmic_accuracy'
	elif assessment == "SightReadingMusicallityTempoStyle".lower():
		assessment = 'sight_reading_musicality_tempo_style'
	elif assessment == "SightReadingToneQuality".lower():
		assessment = 'sight_reading_tone_quality'
	elif assessment == "SightReadingArtistry".lower():
		assessment = 'sight_reading_artistry'

	elif assessment == "SnareEtudeMusicallityTempoStyle".lower() or assessment == 'SnareEtudeMusicallytyTempoStyle'.lower() or assessment == 'SnareEtudeMusicalityTempoStyle'.lower():
		assessment = 'snare_etude_musicality_tempo_style'
	elif assessment == "SnareEtudeNoteAccuracy".lower():
		assessment = 'snare_etude_note_accuracy'
	elif assessment == "SnareEtudeRhythmicAccuracy".lower():
		assessment = 'snare_etude_rhythmic_accuracy'
	elif assessment == "SnareEtudeRudimentalAccuracy".lower():
		assessment = 'snare_etude_rudimental_accuracy'

	elif assessment == "TechnicalEtudeMusicallityTempoStyle".lower() or assessment == "TechnicalEtudeMusicalityTempoStyle".lower():
		assessment = 'technical_etude_musicality_tempo_style'
	elif assessment == "TechnicalEtudeToneQuality".lower():
		assessment = 'technical_etude_tone_quality'
	elif assessment == "TechnicalEtudeNoteAccuracy".lower():
		assessment = 'technical_etude_note_accuracy'
	elif assessment == "TechnicalEtudeRhythmicAccuracy".lower():
		assessment = 'technical_etude_rhythmic_accuracy'
	elif assessment == "TechnicalEtudeArticulation".lower():
		assessment = 'technical_etude_articulation'
	elif assessment == "TechnicalEtudeArtistry".lower():
		assessment = 'technical_etude_artistry'

	elif assessment == "TimpaniEtudeMusicallityTempoStyle".lower() or assessment == "TimpaniEtudeMusicalityTempoStyle".lower():
		assessment = 'timpani_etude_musicality_tempo_style'
	elif assessment == "TimpaniEtudeNoteAccuracy".lower():
		assessment = 'timpani_etude_note_accuracy'
	elif assessment == "TimpaniEtudeRhythmicAccuracy".lower():
		assessment = 'timpani_etude_rhythmic_accuracy'
	elif assessment == "TimpaniEtudeTuningAccuracy".lower():
		assessment = 'timpani_etude_tuning_accuracy'
	else:
		print("{} assesment could't be standardized".format(assessment))

	return extract_alpha(assessment)

class Student:

	def __init__(self,student_id,year,band,instrument):
		self.student_id = student_id
		self.year = year
		self.band = band
		self.instrument = instrument

		if self.instrument == 'Percussion':
			self.scales_chromatic = -1
			self.scales_g = -1
			self.scales_gb = -1
			self.scales_c = -1
			self.scales_f = -1
			self.scales_bb = -1
			self.scales_eb = -1
			self.scales_ab = -1
			self.scales_a = -1
			self.scales_b = -1
			self.scales_d = -1
			self.scales_e = -1
			self.scales_db = -1

			self.mallet_etude_musicality_tempo_style = -1
			self.mallet_etude_note_accuracy = -1
			self.mallet_etude_rhythmic_accuracy = -1

			self.reading_mallet_musicality_style = -1
			self.reading_mallet_note_accuracy_tone = -1
			self.reading_mallet_rhythmic_accuracy_articulation = -1

			self.snare_etude_musicality_tempo_style = -1
			self.snare_etude_note_accuracy = -1
			self.snare_etude_rhythmic_accuracy = -1
			self.snare_etude_rudimental_accuracy = -1

			self.reading_snare_musicality_style = -1
			self.reading_snare_note_accuracy_tone = -1
			self.reading_snare_rhythmic_accuracy_articulation = -1

			self.reading_timpani_rhythmic_accuracy_articulation = -1
			self.reading_timpani_musicality_style = -1
			self.reading_timpani_note_accuracy = -1

			self.timpani_etude_musicality_tempo_style = -1
			self.timpani_etude_note_accuracy = -1
			self.timpani_etude_rhythmic_accuracy = -1

			self.scales_musicality_phrasing_style = -1
			self.scales_note_accuracy = -1
			self.scales_tempo_consistency = -1

		else:
			self.lyrical_etude_musicality_tempo_style = -1
			self.lyrical_etude_tone_quality = -1
			self.lyrical_etude_note_accuracy = -1
			self.lyrical_etude_rhythmic_accuracy = -1
			self.lyrical_etude_artistry = -1

			self.technical_etude_musicality_tempo_style = -1
			self.technical_etude_tone_quality = -1
			self.technical_etude_note_accuracy = -1
			self.technical_etude_rhythmic_accuracy = -1
			self.technical_etude_articulation = -1
			self.technical_etude_artistry = -1

			self.sight_reading_musicality_tempo_style = -1
			self.sight_reading_tone_quality = -1
			self.sight_reading_note_accuracy = -1
			self.sight_reading_rhythmic_accuracy = -1
			self.sight_reading_artistry = -1

			self.scales_chromatic = -1
			self.scales_g = -1
			self.scales_gb = -1
			self.scales_c = -1
			self.scales_f = -1
			self.scales_bb = -1
			self.scales_eb = -1
			self.scales_ab = -1
			self.scales_a = -1
			self.scales_b = -1
			self.scales_d = -1
			self.scales_e = -1
			self.scales_db = -1
			self.scales_tone_quality = -1
			self.scales_musicality_tempo_style = -1
			self.scales_articulation_style = -1


	def add_assessment(self, assessment, val):
		if self.instrument.lower() == 'percussion':
			try:
				val /= percussion_max_scores[standardize(assessment)]
			except:
				print('coundnt find {} in percussion_max_scores'.format(assessment))
		else:
			try:
				val /= instrument_max_scores[standardize(assessment)]
			except:
				print('coundnt find {} in max_scores'.format(assessment))

		if val > 1:
			print(self.student_id, standardize(assessment))

		if assessment == "LyricalEtudeMusicallityTempoStyle".lower():
			self.lyrical_etude_musicality_tempo_style = val
			assessment = 'lyrical_etude_musicality_tempo_style'
		elif assessment == "LyricalEtudeToneQuality".lower():
			self.lyrical_etude_tone_quality = val
			assessment = 'lyrical_etude_tone_quality'
		elif assessment == "LyricalEtudeNoteAccuracy".lower():
			self.lyrical_etude_note_accuracy = val
			assessment = 'lyrical_etude_note_accuracy'
		elif assessment == "LyricalEtudeRhythmicAccuracy".lower():
			self.lyrical_etude_rhythmic_accuracy = val
			assessment = 'lyrical_etude_rhythmic_accuracy'
		elif assessment == "LyricalEtudeArtistry".lower():
			self.lyrical_etude_artistry = val
			assessment = 'lyrical_etude_artistry'

		elif assessment == "MalletEtudeMusicalityTempoStyle".lower():
			self.mallet_etude_musicality_tempo_style = val
			assessment = 'mallet_etude_musicality_tempo_style'
		elif "MalletEtudeNoteAccuracy".lower() in assessment:
			self.mallet_etude_note_accuracy = val
			assessment = 'mallet_etude_note_accuracy'
		elif assessment == "MalletEtudeRhythmicAccuracy".lower():
			self.mallet_etude_rhythmic_accuracy = val
			assessment = 'mallet_etude_rhythmic_accuracy'

		elif assessment == "ReadingMalletMusicalityStyle".lower():
			self.reading_mallet_musicality_style = val
			assessment = 'reading_mallet_musicality_style'
		elif assessment == "ReadingMalletMusicalityTempoStyle".lower():
			self.reading_mallet_musicality_tempo_style = val
			assessment = 'reading_mallet_musicality_tempo_style'
		elif assessment == "ReadingMalletNoteAccuracyTone".lower():
			self.reading_mallet_note_accuracy_tone = val
			assessment = 'reading_mallet_note_accuracy_tone'
		elif assessment == "ReadingMalletRhythmicAccuracyArticulation".lower() or assessment == "ReadingMalletRhythmicAccuracy".lower():
			self.reading_mallet_rhythmic_accuracy_articulation = val
			assessment = 'reading_mallet_rhythmic_accuracy_articulation'

		elif assessment == "ReadingTimpaniRhythmicAccuracyArticulation".lower():
			self.reading_timpani_rhythmic_accuracy_articulation = val
			assessment = 'reading_timpani_rhythmic_accuracy_articulation'
		elif assessment == "ReadingTimpaniMusicalityStyle".lower():
			self.reading_timpani_musicality_style = val
			assessment = 'reading_timpani_musicality_style'
		elif assessment == "ReadingTimpaniNoteAccuracy".lower():
			self.reading_timpani_note_accuracy = val
			assessment = 'reading_timpani_note_accuracy'

		elif assessment == "ReadingSnareNoteAccuracyTone".lower():
			self.reading_snare_note_accuracy_tone = val
			assessment = 'reading_snare_note_accuracy_tone'
		elif assessment == "ReadingSnareRhythmicAccuracyArticulation".lower() or assessment == "ReadingSnareRhythmicAccuracy".lower():
			self.reading_snare_rhythmic_accuracy_articulation = val
			assessment = 'reading_snare_rhythmic_accuracy_articulation'
		elif assessment == "ReadingSnareMusicalityStyle".lower():
			self.reading_snare_musicality_style = val
			assessment = 'reading_snare_musicality_style'
		elif assessment == "ReadingSnareMusicalityTempoStyle".lower():
			self.reading_snare_musicality_tempo_style = val
			assessment = 'reading_snare_musicality_tempo_style'
		elif assessment == "ReadingSnareMusicalityStyle".lower():
			self.reading_snare_musicality_style = val
			assessment = 'reading_snare_musicality_style'

		elif assessment == "ScalesChromatic".lower() or assessment == 'ChromaticScaleChromaticScale'.lower() or assessment == 'ChromaticScaleChromatic'.lower():
			self.scales_chromatic = val
			assessment = 'scales_chromatic'
		elif "ScalesNoteAccuracy".lower() in assessment:
			self.scales_note_accuracy = val
			assessment = 'scales_note_accuracy'
		elif "ScalesTempoConsistency".lower() in  assessment:
			self.scales_tempo_consistency = val
			assessment = 'scales_tempo_consistency'
		elif "ScalesMusicalityPhrasingStyle".lower() in assessment:
			self.scales_musicality_phrasing_style = val
			assessment = 'scales_musicality_phrasing_style'
		elif assessment == "ScalesG".lower() or assessment == "MajorScalesG".lower():
			self.scales_g = val
			assessment = 'scales_g'
		elif assessment == "ScalesGb".lower() or assessment == "MajorScalesGb".lower():
			self.scales_gb = val
			assessment = 'scales_gb'
		elif assessment == "ScalesC".lower() or assessment == "MajorScalesC".lower():
			self.scales_c = val
			assessment = 'scales_c'
		elif assessment == "ScalesF".lower() or assessment == "MajorScalesF".lower():
			self.scales_f = val
			assessment = 'scales_f'
		elif assessment == "ScalesBb".lower() or assessment == "MajorScalesBb".lower():
			self.scales_bb = val
			assessment = 'scales_bb'
		elif assessment == "ScalesEb".lower() or assessment == "MajorScalesEb".lower():
			self.scales_eb = val
			assessment = 'scales_eb'
		elif assessment == "ScalesB".lower() or assessment == "MajorScalesB".lower():
			self.scales_b = val
			assessment = 'scales_b'
		elif assessment == "ScalesD".lower() or assessment == "MajorScalesD".lower():
			self.scales_d = val
			assessment = 'scales_d'
		elif assessment == "ScalesE".lower() or assessment == "MajorScalesE".lower():
			self.scales_e = val
			assessment = 'scales_e'
		elif assessment == "ScalesAb".lower() or assessment == "MajorScalesAb".lower():
			self.scales_ab = val
			assessment = 'scales_ab'
		elif assessment == "ScalesA".lower() or assessment == "MajorScalesA".lower():
			self.scales_a = val
			assessment = 'scales_a'
		elif assessment == "ScalesDb".lower() or assessment == "MajorScalesDb".lower():
			self.scales_db = val
			assessment = 'scales_db'
		elif assessment == "ScalesToneQuality".lower():
			self.scales_tone_quality = val
			assessment = 'scales_tone_quality'
		elif assessment == "ScalesMusicalityTempoStyle".lower():
			self.scales_musicality_tempo_style = val
			assessment = 'scales_musicality_tempo_style'
		elif assessment == "ScalesArticulationStyle".lower():
			self.scales_articulation_style = val
			assessment = 'scales_articulation_style'

		elif assessment == "SightReadingNoteAccuracy".lower():
			self.sight_reading_note_accuracy = val
			assessment = 'sight_reading_note_accuracy'
		elif assessment == "SightReadingRhythmicAccuracy".lower():
			self.sight_reading_rhythmic_accuracy = val
			assessment = 'sight_reading_rhythmic_accuracy'
		elif assessment == "SightReadingMusicallityTempoStyle".lower():
			self.sight_reading_musicality_tempo_style = val
			assessment = 'sight_reading_musicality_tempo_style'
		elif assessment == "SightReadingToneQuality".lower():
			self.sight_reading_tone_quality = val
			assessment = 'sight_reading_tone_quality'
		elif assessment == "SightReadingArtistry".lower():
			self.sight_reading_artistry = val
			assessment = 'sight_reading_artistry'

		elif assessment == "SnareEtudeMusicallityTempoStyle".lower() or assessment == 'SnareEtudeMusicallytyTempoStyle'.lower() or assessment == 'SnareEtudeMusicalityTempoStyle'.lower():
			self.snare_etude_musicality_tempo_style = val
			assessment = 'snare_etude_musicality_tempo_style'
		elif assessment == "SnareEtudeNoteAccuracy".lower():
		 	self.snare_etude_note_accuracy = val
		 	assessment = 'snare_etude_note_accuracy'
		elif assessment == "SnareEtudeRhythmicAccuracy".lower():
			self.snare_etude_rhythmic_accuracy = val
			assessment = 'snare_etude_rhythmic_accuracy'
		elif assessment == "SnareEtudeRudimentalAccuracy".lower():
			self.snare_etude_rudimental_accuracy = val
			assessment = 'snare_etude_rudimental_accuracy'

		elif assessment == "TechnicalEtudeMusicallityTempoStyle".lower() or assessment == "TechnicalEtudeMusicalityTempoStyle".lower():
			self.technical_etude_musicality_tempo_style = val
			assessment = 'technical_etude_musicality_tempo_style'
		elif assessment == "TechnicalEtudeToneQuality".lower():
			self.technical_etude_tone_quality = val
			assessment = 'technical_etude_tone_quality'
		elif assessment == "TechnicalEtudeNoteAccuracy".lower():
			self.technical_etude_note_accuracy = val
			assessment = 'technical_etude_note_accuracy'
		elif assessment == "TechnicalEtudeRhythmicAccuracy".lower():
			self.technical_etude_rhythmic_accuracy = val
			assessment = 'technical_etude_rhythmic_accuracy'
		elif assessment == "TechnicalEtudeArticulation".lower():
			self.technical_etude_articulation = val
			assessment = 'technical_etude_articulation'
		elif assessment == "TechnicalEtudeArtistry".lower():
			self.technical_etude_artistry = val
			assessment = 'technical_etude_artistry'

		elif assessment == "TimpaniEtudeMusicallityTempoStyle".lower() or assessment == "TimpaniEtudeMusicalityTempoStyle".lower():
			self.timpani_etude_musicality_tempo_style = val
			assessment = 'timpani_etude_musicality_tempo_style'
		elif assessment == "TimpaniEtudeNoteAccuracy".lower():
			self.timpani_etude_note_accuracy = val
			assessment = 'timpani_etude_note_accuracy'
		elif assessment == "TimpaniEtudeRhythmicAccuracy".lower():
			self.timpani_etude_rhythmic_accuracy = val
			assessment = 'timpani_etude_rhythmic_accuracy'
		elif assessment == "TimpaniEtudeTuningAccuracy".lower():
			self.timpani_etude_tuning_accuracy = val
			assessment = 'timpani_etude_tuning_accuracy'

		else:
			print("Couldn't find assessment for: " + assessment)

	def __str__(self):
		pass

	def __eq__(self,other):
		return self.student_id == other.student_id

def max_scores_func(year,band):
	bands_dict = {'middleschool':'1','concertband':'2','symphonicband':'3'}
	instrument_max_scores = [line for line in max_scores_file if line[0] == bands_dict[band] and line[1][:4] == year and line[5] == 'NULL']
	percussion_max_scores = [line for line in max_scores_file if line[0] == bands_dict[band] and line[1][:4] == year and line[5] == '1']
	if len(instrument_max_scores) < 5 or len(percussion_max_scores) < 5:
		print('There has been an error retrieving maxscores for {} {}'.format(band,year))
	instrument_max_scores = {standardize(line[2]+line[3]):int(line[4]) for line in instrument_max_scores}
	percussion_max_scores = {standardize(line[2]+line[3]):int(line[4]) for line in percussion_max_scores}
	print(instrument_max_scores,percussion_max_scores)
	return instrument_max_scores, percussion_max_scores


if __name__ == '__main__':
	students = []
	percussion_students = []
	headers = ['ScoreID','Student','Instrument','ScoreGroup','Category','Score']

	max_scores_file = csv.reader(open('All-State Bands Max Score.csv','r'))
	max_scores_file = [line for line in max_scores_file]

	os.chdir(path)
	new_dir = str(os.getcwd())

	for folder in os.listdir(os.getcwd()):
		print(folder)
		if folder.startswith('FBA'):
			os.chdir(f'./{folder}')
			for sub_folder in os.listdir(os.getcwd()):
				if sub_folder in ['symphonicband','concertband','middleschool']:
					os.chdir(f'./{sub_folder}')
					file = 'excel'+sub_folder+'.xlsx'
					try:
						df = pd.read_excel(file, sheet_name='Raw Scores')
						df.columns = headers
					except:
						try:
							df = pd.read_excel(file, sheet_name='Raw Data',usecols='A:F')
							df.columns = headers
						except:
							try:
								df = pd.read_excel(file, sheet_name='Raw',usecols='A:F')
								df.columns = headers
							except:
								df = pd.read_excel(file, sheet_name='Sheet1',usecols='A:F')
								df.columns = headers
					df.year = folder.strip('FBA')
					df.band = sub_folder.split('.')[0]
					# Finds appropriate max scores
					instrument_max_scores, percussion_max_scores = max_scores_func(df.year,df.band)

					# Creates Student objects and adds normalized assessment grades
					print(df.head())
					if df.Instrument.loc[0]!= 'Percussion':
						students.append(Student(int(df.Student.loc[0]),df.year,df.band,df.Instrument.loc[0]))
					else:
						percussion_students.append(Student(int(df.Student.loc[0]),df.year,df.band,df.Instrument.loc[0]))
					for i in range(1,len(df)):
						if df.Instrument.loc[i]!= 'Percussion':
							if df.Student.loc[i] != df.Student.loc[i-1]:
								students.append(Student(int(df.Student.loc[i]),df.year,df.band,df.Instrument.loc[i]))
							students[-1].add_assessment(extract_alpha(df.ScoreGroup.loc[i]+df.Category.loc[i]),df.Score.loc[i])
						else:
							if df.Student.loc[i] != df.Student.loc[i-1]:
								percussion_students.append(Student(int(df.Student.loc[i]),df.year,df.band,df.Instrument.loc[i]))
							percussion_students[-1].add_assessment(extract_alpha(df.ScoreGroup.loc[i]+df.Category.loc[i]),df.Score.loc[i])

					student_df = pd.DataFrame([student.__dict__ for student in students])
					student_df = student_df.set_index('student_id')
					os.chdir('..')
			os.chdir('..')

	with open('normalized_student_scores.csv', 'w') as csv_file:
		writer = csv.writer(csv_file)
		writer.writerow([key for key in students[0].__dict__.keys()])
		for student in students:
			writer.writerow([student.__dict__[key] for key in student.__dict__.keys()])
		csv_file.close()
	with open('normalized_percussion_student_scores.csv', 'w') as csv_file:
		writer = csv.writer(csv_file)
		writer.writerow([key for key in students[0].__dict__.keys()])
		for student in percussion_students:
			writer.writerow([student.__dict__[key] for key in student.__dict__.keys()])
		csv_file.close()
