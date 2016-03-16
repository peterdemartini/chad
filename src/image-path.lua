function splitfilename(strfilename)
	return string.match(strfilename, "(.-)([^\\]-([^\\%.]+))$")
end
local platform = system.getInfo("platformName")
return function(rawFile)
  path,filename,extension = splitfilename(rawFile)
  if extension == 'jpg' then
    return 'images/build/jpgs/'..filename
  end
	local folderName = 'ios'
	if platform == 'Android' then
		local densityName = system.getInfo("androidDisplayDensityName")
		folderName = 'drawable-'..densityName
	end
  return 'images/build/'..folderName..'/'..filename
end
