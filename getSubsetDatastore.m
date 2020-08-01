% getSubsetDatastore(ads,indices) creates a datastore using ads that only
% contains the files and labels indexed by indices.
function dsSubset = getSubsetDatastore(ads,indices)

dsSubset = copy(ads);
dsSubset.Files  = ads.Files(indices);
dsSubset.Labels = ads.Labels(indices);

end