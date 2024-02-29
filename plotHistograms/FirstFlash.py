import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import glob
import os, sys

#print(os.getcwd())
#print(os.listdir(os.getcwd()))

#-------------------------------------------------------------------
nParticle = 100
nTime = 100

xCol = -3
yCol = -2
zCol = -1
IDCol = -4 

EigCol = int(sys.argv[1])

#--------------------------------------------------------------------
# Initialize

EigStrain = np.ones((nParticle,nTime))*123
#EigStrain[:] = np.nan

x_position = np.zeros((nParticle,nTime))
y_position = np.zeros((nParticle,nTime))
z_position = np.zeros((nParticle,nTime))



#----------------------------------------------------------------------
# Read the data
files_org = glob.glob("*.csv")
files =  sorted(files_org)


i=0
for f in files:
	csv = pd.read_csv(f)
	csv = csv[csv.ReasonForTermination == 1]
	npData = csv.to_numpy()
	row, col = npData.shape
	#print("remainParticle =", row)
	
	for j in range (row):
		particleID = int(npData[j,IDCol])
		EigStrain[particleID,i] = npData[j,EigCol]
		x_position[particleID,i] = npData[j,xCol]
		y_position[particleID,i] = npData[j,yCol]
		z_position[particleID,i] = npData[j,zCol]
	i = i+1


#--------------------------------------------------------------------------
# First Flash

criticalStress = float(sys.argv[2])

FlashPosition = []
particleNumber = []
k = 0
l = 0

for nn in range (nParticle):
	if 123 in EigStrain[nn,:]:
		print("particle:",nn, "has been deleted")
	else:
		for mm in range (nTime):
			if (abs(0.001*EigStrain[nn,mm]) > criticalStress):
				FlashPosition.append(-1000*z_position[nn,mm])
				l=l+1
				particleNumber.append(k+1)
				break
		k=k+1
		
		
print(round(l*100/k),"% of particles exceed threshold")
#print (FlashPosition)
x1 = np.zeros(30)
y1 = np.linspace(0,100,30)

x2 = np.zeros(30)
x2[:] = 12.7
y2 = np.linspace(0,100,30)
#--------------------------------------------------------------------

#Plot
w=0.1

plt.scatter(FlashPosition, particleNumber, s = 90, facecolors='none', edgecolors='r')
plt.scatter(x1,y1, marker = 'x', color = 'k')
plt.scatter(x2,y2, marker = 'x', color = 'k')
plt.xlim([-6,16])
plt.ylim([0,100])
plt.xticks([-6,-4,-2,0,2,4,6,8,10,12,14,16])
plt.yticks([0,10,20,30,40,50,60,70,80,90,100])


plt.xlabel('Distance from stimulation grid in mm', fontsize = 15, weight = 'bold')
plt.ylabel('Particle number', fontsize = 15, weight = 'bold')
plt.title(str(round(l*100/k)) + "% of particles exceed threshold" + " " + str(criticalStress) + " " + "Pa",fontsize = 15, weight = 'bold')
plt.tick_params(axis='both',labelsize=15)
plt.tight_layout()
plt.grid(linestyle = '--')
plt.savefig(sys.argv[3]+ str(criticalStress) + ".png", dpi=100)
plt.show()


