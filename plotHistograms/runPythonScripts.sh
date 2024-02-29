#!/bin/bash

python3 FirstFlash.py 0 0.1 crossSerrated_Comp_
python3 FirstFlash.py 0 0.2 crossSerrated_Comp_
python3 FirstFlash.py 0 0.5 crossSerrated_Comp_

python3 FirstFlash.py 2 0.1 crossSerrated_Ext_
python3 FirstFlash.py 2 0.2 crossSerrated_Ext_
python3 FirstFlash.py 2 0.5 crossSerrated_Ext_

python3 particleHist.py 0 crossSerrated_Comp.png
python3 particleHist.py 2 crossSerrated_Ext.png
