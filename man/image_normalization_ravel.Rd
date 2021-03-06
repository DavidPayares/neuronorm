% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/preprocessing.R
\name{image_normalization_ravel}
\alias{image_normalization_ravel}
\title{Wrapper function for RAVEL normalization of T1-weighted images}
\usage{
image_normalization_ravel(
  masked.paths,
  csf.paths,
  ravel.paths,
  demographics,
  brain.mask,
  patients.folder,
  modality = "T1"
)
}
\arguments{
\item{masked.paths}{list or vector of paths of the preprocessed input NIfTI images to be normalized.}

\item{csf.paths}{NIfTI image paths for the binary control region masks.}

\item{ravel.paths}{list or vector of paths of the output NIfTI images.}

\item{demographics}{table of covariates associated to the MRI scans. Number of rows should be equal to the number of images.}

\item{patients.folder}{folder to save the output control mask.}

\item{brain_mask}{NIfTI image path for the binary brain mask. Must have value 1 for the brain tissue and 0 otherwise.}
}
\value{
RAVEL-corrected images are saved in disk.
}
\description{
Ravel intensity normalization using control voxels and clinical covariates.
}
