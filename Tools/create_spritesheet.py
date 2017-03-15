import sys
from os import listdir
from os.path import isfile, join
import math
from subprocess import call

SCRIPT = sys.argv[0]

source_dir = ''
tile_width = 0
tile_height = 0
nb_columns = 0
destination = ''
filenames = []
image_magick_command = ''

def show_infos():
	print("Source: " + source_dir)
	print("Number of files in source: " + str(len(filenames)))
	print("Tile width: " + str(tile_width))
	print("Tile height: " + str(tile_height))
	print("Nb columns: " + str(nb_columns))
	print("Destination: " + destination)

def generate_magick_command():
	global image_magick_command
	prefix = 'magick montage '
	postfix = destination
	root = ''
	for filename in filenames:
		root += filename + ' '
	root += '-tile '+str(nb_columns)+'x'+str(math.ceil(len(filenames)/nb_columns)) + ' '
	root += '-geometry '+str(tile_width)+'x'+str(tile_height)+'+0+0 '
	root += '-background transparent '
	image_magick_command = prefix + root + postfix

def run_command(command):
	print('Running command: ' + image_magick_command)
	splitted_command = command.split(' ')
	print('...')
	return_code = call(splitted_command)

def main():
	if len(sys.argv)-1 < 5: raise ValueError('5 Parameters are required, images directory, tile width, tile height, nb columns, file destination')
	global source_dir, filenames, tile_width, tile_height, nb_columns, destination, image_magick_command
	source_dir = sys.argv[1]
	filenames = [join(source_dir, f) for f in listdir(source_dir) if isfile(join(source_dir, f))]
	tile_width = int(sys.argv[2])
	tile_height = int(sys.argv[3])
	nb_columns = int(sys.argv[4])
	destination = sys.argv[5]
	show_infos()
	generate_magick_command()
	run_command(image_magick_command)
	print('File "'+destination+'" generated!')
	print('Done')	

if __name__ == "__main__":
	main()