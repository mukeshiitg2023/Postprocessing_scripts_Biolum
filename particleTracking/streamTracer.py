from paraview.simple import *
animationScene1 = GetAnimationScene()
contour1 = GetActiveSource()

for i in range(0,100):
	animationScene1.GoToNext()
	SaveData('/home/mukesh/Mukesh/Openfoam_cases/TEST/postProcessing/annular45deg_%03d.csv'%i, proxy=contour1)
