
## ----------------------- Installation  --------------------------

# install.packages("devtools")
devtools::install_github("jdwor/neuronorm@main")

## ----------------------- Data Loading  --------------------------

# Get general folder
folder <- system.file("extdata", package = "neurodata")

# Get covariates
covariates <- system.file("covariates.txt", package = "neurodata")

# Read covariates information
clinical_info <- read.csv(file = covariates, sep = ';')

## ----------------------- Preprocessing  --------------------------

require('neuronorm')
# Preprocess MRI scans: 'N4' inhomogeneity correction, 'SyN' non-linear transformation to MNI152 atlas template
# Brain extraction, Spatial informed MRI scan , a.k.a., brain segmentation and RAVEL intensity normalization only for T1-w images.
paths_preprocess_patients <- preprocess_patients(folder, clinical_info)

# Outputs paths of the preprocessed MRI scans.
paths_preprocess_patients$patient02$ravel

## ----------------------- Image Visualization  --------------------------

require('oro.nifti')
# visualize a preprocessed MRI scan for a patient.
img <- readNIfTI(file.path(paths_preprocess_patients$patient02$registered[1]))
orthographic(img, reorient = F)

## -------------------- Preprocessing for one patient -----------------------------------

# Folder of the patient
patient_folder <- file.path(folder,"patient01")

## Getting the paths of the MRI scan sequences for one patient
## the NeuroNorm built-in function load_mri_patient() can be used for this.
sequences <- load_mri_patient(patient_folder)


## Getting preferred atlas template and template mask
## Using the MNI152 template available in the MNITemplate package
library(MNITemplate)
atlas <- getMNIPath()
atlas_mask <- readMNI("Brain_Mask")

## Preprocessing the patient's sequences
patient_preprocessed_mri <- preprocess_modalities(mri.patient = sequences,
                                                  folder.patient = patient_folder, modalities = c('T1','T2','FLAIR'),
                                                  atlas = atlas, mask = atlas_mask,
                                                  inhomogeneity = 'N4',
                                                  transformation = 'SyN')


## -------------------- RAVEL for other modalities  -----------------------------------

## Defining the RAVEL output files for the patients
## with a T2-weighted sequence (patient 1,2 and 4)
patients <- c(1,2,4)
output_files <- lapply(patients, function(x) {file.path(folder, paste0("patient0",x),"T2_ravel.nii.gz")})

## Getting the files of the preprocessed images (without intensity normalization)
## and the CSF masks computed by the preprocessing.
csf_paths <- lapply(paths_preprocess_patients[patients], function(x){x$csf_mask})
masked_paths <- lapply(paths_preprocess_patients[patients], function(x){x$syn_masked[2]})

## Subseting covariares info
cov_pat <- clinical_info[clinical_info$patient %in% patients,]

## Normalizing T2 sequences with RAVEL
image_normalization_ravel(masked.paths = masked_paths, csf.paths = csf_paths, ravel.paths = output_files, demographics = cov_pat, brain.mask = atlas_mask, patients.folder = folder, modality = "T2")
