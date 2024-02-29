import os
from paraview.simple import *
animationScene1 = GetAnimationScene()
contour1 = GetActiveSource()

Base_filename="annular_45deg"
output_directory = "CSV_annular_45deg"       # relative path

for i in range(0,100):
	animationScene1.GoToNext()
	parent_dir = os.path.dirname(os.getcwd())  # Get parent directory of current working directory
	address = os.path.join(parent_dir,output_directory,Base_filename+'%03d.csv' % i)
	SaveData(address, proxy=contour1)

