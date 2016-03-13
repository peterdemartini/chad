#!/bin/bash

IMAGES_DIR="$(pwd)/images"
function get_input_path() {
  local filename="$1"
  echo "${IMAGES_DIR}/raw/${filename}"
}

function get_ios_path() {
  local filename="$1"
  local ext="$2"
  echo "${IMAGES_DIR}/build/ios/${filename%.png}${ext}"
}

function convert_ios() {
  local filename="$1"
  local input_path=$(get_input_path $filename)
  local ios_1x_path=$(get_ios_path $filename ".png")
  local ios_2x_path=$(get_ios_path $filename "@2x.png")
  local ios_3x_path=$(get_ios_path $filename "@3x.png")

  echo "### making ios path..."
  mkdir -p "$IMAGES_DIR/build/ios"

  echo "### creating @3x..."
  convert -resize 100% "${input_path}" "${ios_3x_path}"
  echo "### creating @2x..."
  convert -resize 50% "${input_path}" "${ios_2x_path}"
  echo "### creating @1x..."
  convert -resize 25% "${input_path}" "${ios_1x_path}"
}

function get_android_path() {
  local dirname="$1"
  local filename="$2"
  echo "${IMAGES_DIR}/build/${dirname}/${filename}"
}

function convert_android() {
  local filename="$1"
  local input_path=$(get_input_path $filename)

  echo "### making android paths"
  mkdir -p "${IMAGES_DIR}/build/drawable-mdpi"
  mkdir -p "${IMAGES_DIR}/build/drawable-hdpi"
  mkdir -p "${IMAGES_DIR}/build/drawable-xhdpi"
  mkdir -p "${IMAGES_DIR}/build/drawable-xxhdpi"
  mkdir -p "${IMAGES_DIR}/build/drawable-xxxhdpi"

  local mdpi_path=$(get_android_path "drawable-mdpi" $filename)
  local hdpi_path=$(get_android_path "drawable-hdpi" $filename)
  local xhdpi_path=$(get_android_path "drawable-xhdpi" $filename)
  local xxhdpi_path=$(get_android_path "drawable-xxhdpi" $filename)
  local xxxhdpi_path=$(get_android_path "drawable-xxxhdpi" $filename)

  echo "### creating mdpi..."
  convert -resize %25 "${input_path}" "${mdpi_path}"
  echo "### creating hdpi..."
  convert -resize %50 "${input_path}" "${hdpi_path}"
  echo "### creating xhdpi..."
  convert -resize %100 "${input_path}" "${xhdpi_path}"
  echo "### creating xxhdpi..."
  convert -resize %150 "${input_path}" "${xxhdpi_path}"
  echo "### creating xxxhdpi..."
  convert -resize %200 "${input_path}" "${xxxhdpi_path}"
}

echo "### Cleaning up..."
rm -rf "$IMAGES_DIR/build"

echo "### Copying jpgs..."
mkdir -p "${IMAGES_DIR}/build/jpgs"

JPG_IMAGES=`find "${IMAGES_DIR}/raw" -name "*.jp*g"`
for image_path in $JPG_IMAGES; do
  FILENAME=`basename "${image_path}"`
  cp "${IMAGES_DIR}/raw/${FILENAME}" "${IMAGES_DIR}/build/jpgs/${FILENAME}"
done

echo "### Starting to convert png files..."
PNG_IMAGES=`find "${IMAGES_DIR}/raw" -name "*.png"`
for image_path in $PNG_IMAGES; do
  FILENAME=`basename "${image_path}"`
  echo "### CONVERTING ${FILENAME}"
  echo "### Converting image ${FILENAME} for ios..."
  convert_ios "$FILENAME"
  echo "### Converted ios images for ${FILENAME}"

  echo "### Converting image ${FILENAME} for android..."
  convert_android "$FILENAME"
  echo "### Converted android images for ${FILENAME}"
done
