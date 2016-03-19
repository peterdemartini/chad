#!/bin/bash

IMAGES_DIR="./images"
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
  echo "./build/${dirname}"
}

function convert_android() {
  local filename="$1"
  local input_path=$(get_input_path $filename)

  local mdpi_path=$(get_android_path "drawable-mdpi")
  local hdpi_path=$(get_android_path "drawable-hdpi")
  local xhdpi_path=$(get_android_path "drawable-xhdpi")
  local xxhdpi_path=$(get_android_path "drawable-xxhdpi")
  local xxxhdpi_path=$(get_android_path "drawable-xxxhdpi")

  echo "### resizing for android..."
  ./resize-drawable --file "${input_path}" \
    --mdpi "${mdpi_path}" \
    --hdpi "${hdpi_path}" \
    --xhdpi "${xhdpi_path}" \
    --xxhdpi "${xxhdpi_path}"
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
