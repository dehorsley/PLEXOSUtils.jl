using PLEXOSUtils

# TODO: Actually test things
function runtest(zippath::String)
    PLEXOSSolutionDataset(zippath)
    h5plexos(zippath, replace(zippath, ".zip" => ".h5"))
end

testfolder = dirname(@__FILE__) * "/"

zipfiles = ["Model Base_8200 Solution.zip",
            "Model DAY_AHEAD_ALL_TX Solution.zip"]

for zipfile in zipfiles
    println(zipfile)
    runtest(testfolder * zipfile)
end
