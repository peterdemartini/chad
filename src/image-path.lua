function splitfilename(strfilename)
	return string.match(strfilename, "(.-)([^\\]-([^\\%.]+))$")
end
return function(rawFile)
  path,filename,extension = splitfilename(rawFile)
  print('filename', path, filename, extension)
  if extension == 'jpg' then
    return 'images/build/jpgs/'..filename
  end
  return 'images/build/ios/'..filename
end
