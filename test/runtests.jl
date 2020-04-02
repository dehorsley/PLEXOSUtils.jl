using PLEXOSUtils

testfolder(filename::String) = dirname(@__FILE__) * "/" * filename

# TODO: Actually test things
function runtest(zippath::String)
    PLEXOSSolutionDataset(zippath)
    h5plexos(zippath, replace(zippath, ".zip" => ".h5"))
end

runtest(testfolder("Model Base_8200 Solution.zip"))
runtest(testfolder("Model DAY_AHEAD_ALL_TX Solution.zip"))
