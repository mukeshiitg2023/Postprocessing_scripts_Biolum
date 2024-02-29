from paraview.simple import *
animationScene1 = GetAnimationScene()
contour1 = GetActiveSource()

for i in range(0,100):
	animationScene1.GoToNext()
	SaveData('/scratch/hidex_v3_RANS/hidexStreamline%03d.csv'%i, proxy=contour1)

