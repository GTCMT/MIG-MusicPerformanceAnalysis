import numpy as np
import os
import csv
import sys
import matplotlib.pyplot as plt
import statistics

global data
global students
global years
global bands
global instruments
global exercises

filename = 'normalized_student_scores.csv'
path = '../../../MIG-FbaData'

def load_data(filename):
	file = csv.reader(open(filename))
	raw = [line for line in file]
	heads = raw[0]
	raw = raw[1:]
	table = [line[4:] for line in raw]

	# Axis Headers
	students = np.unique([line[0] for line in raw])
	years = np.unique([line[1] for line in raw])
	bands = np.unique([line[2] for line in raw])
	instruments = np.unique([line[3] for line in raw])
	exercises = np.array(heads[4:])

	# Creates empty table with dimensions
	data = [[[[[] for e in range(len(exercises))] for i in range(len(instruments))] for b in range(len(bands))] for y in range(len(years))]

	# Fills data table
	for y in range(len(table)):
		year = np.where(years == raw[y][1])[0][0]
		band = np.where(bands == raw[y][2])[0][0]
		inst = np.where(instruments == raw[y][3])[0][0]
		for exer in range(len(table[y])):
			if table[y][exer] == '-1' or table[y][exer] == '' or float(table[y][exer]) > 1:
				continue
			if data[year][band][inst][exer] == 0:
				data[year][band][inst][exer] = [table[y][exer]]
			else:
				data[year][band][inst][exer].append(table[y][exer])

	data = np.array(data)

	return data, students, years, bands, instruments, exercises

#########################     QUERY     #########################

def list_input(question,items,extras=['Aggregate','All']):
	count = 0

	# Prints items in selection
	for item in items:
		print(f'{count})\t{item}')
		count +=1

	# Prints extras
	for extra in extras:
		print(f'{count})\t{extra}')
		count +=1
	inp = input(question)
	inp = [int(i.strip()) for i in inp.split(',')]

	# Formats input if aggregate is in user input
	aggregate = len(items) in inp
	if len(items) in inp:
		inp.remove(len(items))
	if len(items)+1 in inp:
		inp = ['All']
	return inp, aggregate

def exercises_query(ask=True,inp=['All']):
	global data
	global exercises

	if ask:
		# User Input
		inp, aggregate = list_input('Which Exercises would you like to see? ',exercises)
	else:
		# Command Line Input
		if 'Aggregate' in inp:
			aggregate = True
			inp.remove('Aggregate')
			inp = [int(i) for i in inp]
		else:
			aggregate = False
			if inp != ['All']:
				inp = inp = [int(i.strip()) for i in inp]

	if aggregate:
		exercises = ['Aggregate']
		if inp == ['All'] or inp == []:
			data = np.sum(data, axis=3)
		else:
			temp_data = data[:,:,:,[inp[0]]]
			for exer in inp[1:]:
				temp_data = np.append(temp_data,data[:,:,:,[exer]], axis=3)
			data = np.sum(temp_data,axis=3)
	elif inp != ['All']:
		temp_data = data[:,:,:,[inp[0]]]
		temp_exercises = [exercises[inp[0]]]
		for exer in inp[1:]:
			temp_exercises.append(exercises[exer])
			temp_data = np.append(temp_data,data[:,:,:,[exer]], axis=3)
		data = temp_data
		exercises = temp_exercises

def instruments_query(ask=True,aggregate=False,inp=['All']):
	global data
	global instruments

	if ask:
		inp, aggregate = list_input('Which Exercises would you like to see? ',instruments)
	else:
		if 'Aggregate' in inp and ask == False:
			aggregate = True
			inp.remove('Aggregate')
			inp = [int(i) for i in inp]
		else:
			aggregate = False
			if inp != ['All']:
				inp = [int(i.strip()) for i in inp]

	if aggregate:
		instruments = ['Aggregate']
		if inp == ['All'] or inp == []:
			data = np.sum(data, axis=2)
		else:
			temp_data = data[:,:,[inp[0]]]
			for inst in inp[1:]:
				temp_data = np.append(temp_data,data[:,:,[inst]], axis=2)
			data = np.sum(temp_data,axis=2)
	elif inp != ['All']:
		temp_data = data[:,:,[inp[0]]]
		temp_instruments = [instruments[inp[0]]]
		for inst in inp[1:]:
			temp_instruments.append(instruments[inst])
			temp_data = np.append(temp_data,data[:,:,[inst]], axis=2)
		data = temp_data
		instruments = temp_instruments

def bands_query(ask=True,aggregate=False,inp=['All']):
	global data
	global bands

	if ask:
		inp, aggregate = list_input('Which Exercises would you like to see? ',bands)
	else:
		if 'Aggregate' in inp and ask == False:
			aggregate = True
			inp.remove('Aggregate')
			inp = [int(i) for i in inp]
		else:
			aggregate = False
			if inp != ['All']:
				inp = [int(i.strip()) for i in inp]

	if aggregate:
		bands = ['Aggregate']
		if inp == ['All'] or inp == []:
			data = np.sum(data, axis=1)
		else:
			temp_data = data[:,[inp[0]]]
			for band in inp[1:]:
				temp_data = np.append(temp_data,data[:,[band]], axis=1)
			data = np.sum(temp_data,axis=1)
	elif inp != ['All']:
		temp_data = data[:,[inp[0]]]
		temp_bands = [bands[inp[0]]]
		for band in inp[1:]:
			temp_bands.append(bands[band])
			temp_data = np.append(temp_data,data[:,[band]], axis=1)
		data = temp_data
		bands = temp_bands

def years_query(ask=True,inp=['All']):
	global data
	global years

	if ask:
		inp, aggregate = list_input('Which Exercises would you like to see? ',years)
	else:
		if 'Aggregate' in inp and ask == False:
			aggregate = True
			inp.remove('Aggregate')
			inp = [int(i) for i in inp]
		else:
			aggregate = False
			if inp != ['All']:
				inp = [int(i.strip()) for i in inp]

	if aggregate:
		years = ['Aggregate']
		if inp == ['All'] or inp == []:
			data = np.sum(data, axis=0)
		else:
			temp_data = data[[inp[0]]]
			for band in inp[1:]:
				temp_data = np.append(temp_data,data[[band]], axis=0)
			data = np.sum(temp_data,axis=0)
	elif inp != ['All']:
		temp_data = data[[inp[0]]]
		temp_years = [years[inp[0]]]
		for band in inp[1:]:
			temp_years.append(years[band])
			temp_data = np.append(temp_data,data[[band]], axis=0)
		data = temp_data
		years = temp_years


#########################   FUNCTIONS   #########################

def draw_line(func):
	global data
	global years
	global bands
	global instruments
	global exercises

	xs = [years,bands,instruments,exercises]
	xlabels = ['Years','Bands','Instruments','Exercises']
	i = 0

	x = years
	xlabel = 'Years'

	while list(x) == ['Aggregate']:
		i += 1
		x = xs[i]
		xlabel = xlabels[i]


	title = 'Average Score'
	axis = 4 - [years[0],bands[0],instruments[0],exercises[0]].count('Aggregate')

	if axis == 0:
		scores = [float(score) for score in data]
		print('The mean score of absolutely everything is {}'.format(func(scores)))

	if axis == 1:
		line = []

		# Identifies which feature has not been aggregated
		if 'Aggregate' not in years:
			title += ' by Year'
			x = years
			xlabel = 'Years'
		elif 'Aggregate' not in bands:
			title += ' by Band'
			x = bands
			xlabel = 'Bands'
		elif 'Aggregate' not in instruments:
			title += ' by Instrument'
			x = instruments
			xlabel = 'Instruments'
		elif 'Aggregate' not in exercises:
			title += ' by Exercises'
			x = exercises
			xlabel = 'Exercises'


		for item in data:
			scores = [float(score) for score in item]
			line.append(func(scores))
		ax.plot(x, line)
		if xlabel == 'Instruments' or xlabel == 'Exercises':

			plt.xticks(x,x,rotation='vertical')
			pos = ax.get_position()
			ax.set_position([pos.x0,pos.y0+0.25,pos.width,pos.height-0.25])
		ax.set_ylabel('Score')
		ax.set_xlabel(xlabel)
		plt.show()

	if axis == 2:

		if x is years and 'Aggregate' not in years:
			labels = [bands,instruments,exercises]
			labels = [label for label in labels if list(label) != ['Aggregate']][0]
		elif x is bands and 'Aggregate' not in bands:
			labels = [years,instruments,exercises]
			labels = [label for label in labels if list(label) != ['Aggregate']][0]
		elif x is instruments and 'Aggregate' not in instruments:
			labels = [years,bands,exercises]
			labels = [label for label in labels if list(label) != ['Aggregate']][0]
		elif x is exercises and 'Aggregate' not in exercises:
			labels = [years,bands,instruments]
			labels = [label for label in labels if list(label) != ['Aggregate']][0]

		lines = []
		for i in data:
			line = []
			for j in i:
				scores = [float(score) for score in j]
				line.append(func(scores))
			lines.append(line)
		for l in range(len(lines[0])):
			ax.plot(x, [line[l] for line in lines],label=labels[l])


		ax.legend()
		ax.set_ylabel('Score')
		ax.set_xlabel(xlabel)
		plt.title(title)
		plt.show()

	if axis == 3:
		if x is years and 'Aggregate' not in years:
			labels = [bands,instruments,exercises]
			labels = [label for label in labels if list(label) != ['Aggregate']]
		elif x is bands and 'Aggregate' not in bands:
			labels = [years,instruments,exercises]
			labels = [label for label in labels if list(label) != ['Aggregate']]
		elif x is instruments and 'Aggregate' not in instruments:
			labels = [years,bands,exercises]
			labels = [label for label in labels if list(label) != ['Aggregate']]
		elif x is exercises and 'Aggregate' not in exercises:
			labels = [years,bands,instruments]
			labels = [label for label in labels if list(label) != ['Aggregate']]

		groups = []
		for group in data:
			line = []
			for member in group:
				for item in member:
					scores = [float(score) for score in item]
					line.append(func(scores))
			groups.append(line)

		for l in range(len(groups[0])):
			ax.plot(x, [line[l] for line in groups],label=labels[0][l%len(labels[0])]+' '+labels[1][l//len(labels[0])])

		ax.legend()
		ax.set_ylabel('Score')
		ax.set_xlabel(xlabel)
		plt.title(title)
		plt.show()

	if axis == 4:
		if x_axis == 'Years':
			labels = [bands,instruments,exercises]
		elif x_axis == 'Bands':
			labels = [years,instruments,exercises]
		elif x_axis == 'Instruments':
			labels = [years,bands,exercises]
		elif x_axis == 'Exercises':
			labels = [years,bands,instruments]

		groups = []
		for year in data:
			line = []
			for band in year:
				for instrument in band:
					for exercise in instrument:
						scores = [float(score) for score in exercise]
						line.append(func(scores))
			groups.append(line)

		for l in range(len(groups[0])):
			i = l
			band_index = i//(len(labels[1])*len(labels[2]))
			i -= band_index*len(labels[1])*len(labels[2])
			instrument_index = i//len(labels[2])
			i -= instrument_index*len(labels[2])
			ax.plot(x, [line[l] for line in groups],label=labels[0][band_index]+' '+labels[1][instrument_index]+' '+labels[2][i])

		ax.legend()
		ax.set_ylabel('Score')
		ax.set_xlabel(xlabel)
		plt.title(title)
		plt.show()

def draw_dist(interval=0.1):
	global data

	axis = 4 - [years[0],bands[0],instruments[0],exercises[0]].count('Aggregate')

	x = []
	val = 0
	while val < 1:
		x.append(val)
		val += interval
	x.append(val)

	freqs = []

	if axis == 0:
		labels = ['All Scores']
		data = [float(x) for x in data]
		freq = []
		for i in range(len(x)-1):
			freq.append(np.sum(np.where(np.array(data) < x[i+1])) - np.sum(np.where(np.array(data) < x[i])))
		freqs.append(freq)
	if axis == 1:
		
		labels = [label for label in [years,bands,instruments,exercises] if list(label) != ['Aggregate']][0]

		data = [[float(x) for x in y] for y in data]
		for group in data:
			freq = []
			for i in range(len(x)-1):
				freq.append(np.sum(np.where(np.array(group) < x[i+1])) - np.sum(np.where(np.array(group) < x[i])))
			freqs.append(freq)

	if axis == 2:

		labels = [label for label in [years,bands,instruments,exercises] if list(label) != ['Aggregate']]
		labels1 = list(labels[0])
		labels2 = list(labels[1])

		labels = []
		for label1 in labels1:
			for label2 in labels2:
				labels.append(label1 + ' ' + label2)

		data = [[[float(x) for x in y] for y in z] for z in data]
		for group in data:
			for member in group:
				freq = []
				for i in range(len(x)-1):
					freq.append(np.sum(np.where(np.array(member) < x[i+1])) - np.sum(np.where(np.array(member) < x[i])))
				freqs.append(freq)

	if axis == 3:

		labels = [label for label in [years,bands,instruments,exercises] if list(label) != ['Aggregate']]
		labels1 = list(labels[0])
		labels2 = list(labels[1])
		labels3 = list(labels[2])

		labels = []
		for label1 in labels1:
			for label2 in labels2:
				for label3 in labels3:
					labels.append(label1 + ' ' + label2 + ' ' + label3)

		data = [[[[float(x) for x in y] for y in z] for z in a] for a in data]
		for group in data:
			for member in group:
				for item in member:
					freq = []
					for i in range(len(x)-1):
						freq.append(np.sum(np.where(np.array(item) < x[i+1])) - np.sum(np.where(np.array(item) < x[i])))
					freqs.append(freq)

	if axis == 4:

		labels = []
		for year in years:
			for band in bands:
				for instrument in instruments:
					for exercise in exercises:
						labels.append(year + ' ' + band + ' ' + instrument + ' ' + exercise)

		data = [[[[[float(score) for score in exer] for exer in inst] for inst in band] for band in year] for year in data]
		for year in data:
			for band in year:
				for instrument in band:
					for exercise in instrument:
						freq = []
						for i in range(len(x)-1):
							freq.append(np.sum(np.where(np.array(exercise) < x[i+1])) - np.sum(np.where(np.array(exercise) < x[i])))
						freqs.append(freq)

	for f in range(len(freqs)):
		ax.plot(x[:-1],freqs[f],label=labels[f])
	ax.legend()
	ax.set_ylabel('Frequency')
	ax.set_xlabel('Score')
	plt.title('Distribution')
	plt.show()

def mean(values):
	if len(values) == 0:
		return 0
	return sum(values)/len(values)

def graph(ask=True,inp=0,distribution=False):
	global functions

	if ask:
		inp, distribution = list_input('Which of the following functions would you like to be performed? (Pick One) ', [str(function) for function in function_names], extras=['Distribution'])
		if distribution:
			interval = float(input('What would you like to be the interval? (0.1 Reccomended) '))
		else:
			inp = inp[0]

	if distribution:
		try:
			draw_dist(interval=interval)
		except:
			draw_dist()
	else:
		draw_line(functions[inp])



#########################      MAIN     #########################

if __name__ == '__main__':
	os.chdir(path)
	data, students, years, bands, instruments, exercises = load_data(filename)
	fig, ax = plt.subplots(figsize=[12,7])
	functions = [mean,statistics.median,max,min,len,statistics.stdev,statistics.variance]
	function_names = ['Mean','Median','Max','Min','Count','Standard Deviation','Variance']

	# Query

	if len(sys.argv) == 1:
		# Uses user interface to generate query
		exercises_query(ask=True)
		instruments_query(ask=True)
		bands_query(ask=True)
		years_query(ask=True)

		graph(ask=True)

	elif len(sys.argv) == 2:
		if sys.argv[1] == 'Preset1':
			exercises_query(ask=False,inp = ['Aggregate'])
			instruments_query(ask=False,inp = ['Aggregate'])
			bands_query(ask=False,inp = ['All'])
			years_query(ask=False,inp = ['All'])

			graph(ask=False)

		# Write presets into here

	elif len(sys.argv) >= 5:
		# Uses system arguements to generate query
		exercises_query(ask=False,inp = sys.argv[4].split(','))
		instruments_query(ask=False,inp = sys.argv[3].split(','))
		bands_query(ask=False,inp = sys.argv[2].split(','))
		years_query(ask=False,inp = sys.argv[1].split(','))

		try:
			func = sys.argv[5]
			try:
				func = int(func)
			except:
				func = (function_names+['Distribution']).index(func)
			distribution = func == len(functions)
			graph(ask=False,inp=func,distribution=distribution)

		except:
			graph(ask=True)
















