% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preprocessing.R
\name{preprocess_modalities}
\alias{preprocess_modalities}
\title{Preprocess group of MRI scan for one patient}
\usage{
preprocess_modalities(
  mri.patient,
  folder.patient,
  modalities,
  atlas,
  mask,
  inhomogeneity = "N4",
  transformation = "SyN"
)
}
\arguments{
\item{mri.patient}{path of the MRI scans.}

\item{folder.patient}{folder containing the MRI scans. This folder usually refers to the patient.}

\item{modalities}{vector of strings containing the modalities to be preprocessed. It must always contains the T1-weighted sequence scan.}

\item{atlas}{atlas template in NifTI format to spatially register the MRI scans. By default the MNI152 atlas template is used.}

\item{mask}{brain mask in NifTI format of the atlas template to performed the skull stripping.}

\item{inhomogeneity}{inhomogeneity correction algorithm to be applied. The correction by default is the 'N4' bias correction.}

\item{transformation}{non-linear transformation for registering the T1-w MRI scan to the reference template. 'SyN' transformation is used by default.}
}
\value{
paths of preprocessed MRI scans.
}
\description{
This function preprocesses raw T1-weighted, T2-weighted and FLAIR MRI scans and generates a segmentation MRI scan using the FAST algorithm.
The preprocesising steps comprises imhomogeneity correction 'N4', coregistration of other sequences to the T1-weighted scan,
non-linear registration to the MNI152 template with an isotropic voxel size of 1mm,
using the 'SyN' transformation, skull stripping, brain segmentation and intensity normalization using the RAVEL or White Stripe algorithms.
}
\examples{
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
}
