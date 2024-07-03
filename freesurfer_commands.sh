# for each subject, the following FreeSurfer commands (v7.3.2) were used parallelized on several machines. Please contact me for more information on that.

# the script can be calles like that:
# bash freesurfer_commands.sh sub-001

SUBJECT_ID=$1 #cache input as SUBJECT_ID
PROJECT_DIR=/Users/melissa/Dokumente/PhD/ThalamusVolumePrematurity

export FREESURFER_HOME=/sw/freesurfer/7.3.2
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh
export FSFAST_HOME=/sw/freesurfer/7.3.2
export MNI_DIR=/sw/freesurfer/7.3.2/mni 
export SUBJECTS_DIR=${PROJECT_DIR}/preprocData/freesurfer_7.3.2 #where the output will be stored

#----------------------
# 1. recon-all
#----------------------
# by calling mri_convert first, BIDS can be integrated more easily with the FreeSurfer data structure requirements
mkdir -p ${SUBJECTS_DIR}/${SUBJECT_ID}/mri/orig
mri_convert ${PROJECT_DIR}/${SUBJECT_ID}/ses-01/anat/${SUBJECT_ID}_ses-01_T1w.nii.gz ${SUBJECTS_DIR}/${SUBJECT_ID}/mri/orig/001.mgz

recon-all -subject ${SUBJECT_ID} -all -qcache -3T



#----------------------
# 2. thalamus segmentation
#----------------------
segment_subregions thalamus --cross ${SUBJECT_ID}





