# After all subjects are preprocessed, aseg volumes and thalamic nuclei volumes can be extracted like this:
# A subjectlist.txt file is required containing all subjectnames (example can be found in /data)


PROJECT_DIR=/Users/melissa/Dokumente/PhD/ThalamusVolumePrematurity

export FREESURFER_HOME=/sw/freesurfer/7.3.2
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh
export FSFAST_HOME=/sw/freesurfer/7.3.2
export MNI_DIR=/sw/freesurfer/7.3.2/mni 
export SUBJECTS_DIR=${PROJECT_DIR}/preprocData/freesurfer_7.3.2 #where the output will be stored

cd ${PROJECT_DIR}/data

# extract aseg volumes
asegstats2table --subjectsfile=subjectlist.txt -t aseg_BEST7.3.2_volume.txt -m volume --skip

# extract thalamic nuclei volumes into one text file
quantifyThalamicNuclei.sh thalamus_volumes_BEST.txt T1 ${SUBJECTS_DIR}