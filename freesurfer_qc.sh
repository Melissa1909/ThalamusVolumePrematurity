# FreeSurfer QA tools were used for quality control.
# A subjectlist.txt file as found in /data is needed.

PROJECT_DIR=/Users/melissa/Dokumente/PhD/ThalamusVolumePrematurity
OUT_DIR=${PROJECT_DIR}/preprocData/freesurfer_7.3.2/qa
mkdir -p ${OUT_DIR}

export FREESURFER_HOME=/sw/freesurfer/7.3.2
source ${FREESURFER_HOME}/SetUpFreeSurfer.sh
export FSFAST_HOME=/sw/freesurfer/7.3.2
export MNI_DIR=/sw/freesurfer/7.3.2/mni 
export SUBJECTS_DIR=${PROJECT_DIR}/preprocData/freesurfer_7.3.2 #where the output will be stored

for SUBJECT in $(cat subjectlist.txt); do 
    qatools.py --subjects ${SUBJECTS_DIR} --subjects ${SUBJECT} --output_dir ${OUT_DIR} --screenshots
done