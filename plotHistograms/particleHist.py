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

	
#----------------------------------------------------------
# Max stress

maxValue = np.zeros(row)
k=0

for nn in range(nParticle):
	if 123 in EigStrain[nn,:]:
		print("particle:",nn, "has been deleted")
	else:
		maxValue[k] = np.max(abs(EigStrain[nn,:]))
		k=k+1 		

stress = 0.001*maxValue

#--------------------------------------------------------------------------
#Plot
w=0.05
#counts, bins = np.histogram(stress,bins=np.arange(min(stress),max(stress)+w,w))
counts, bins = np.histogram(stress,bins=np.arange(0,max(stress),w))
counts = counts/np.sum(counts)
plt.hist(bins[:-1],bins, weights=counts,edgecolor='black', histtype='bar')
plt.xlim([0,1])
plt.ylim([0,0.35])
#plt.xticks([0,0.04,0.08,0.12,0.16,0.2,0.24,0.28,0.32,0.36,0.40,0.44,0.48,0.52,0.56,0.6,0.64,0.68,0.72,0.76,0.80,0.84,0.88,0.92,0.96,1.0])
plt.yticks([0,0.05,0.10,0.15,0.20,0.25,0.30,0.35])
plt.xticks([0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0])

plt.xlabel('MaximumStress(Pa)', fontsize = 15, weight = 'bold')
plt.ylabel('Probability', fontsize = 15, weight = 'bold')
#plt.title("Traction",fontsize = 20, weight = 'bold')
plt.tick_params(axis='both',labelsize=15)
plt.tight_layout()
plt.grid(linestyle = '--')
plt.savefig(sys.argv[2], dpi=100)
plt.show()


