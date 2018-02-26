# Patricia Tran
# Bash scripts to process the metagenome data, once the bins are done

# assess quality of MAGS
checkm lineage_wf -x fna -x

## Make a tree using pyparanoid
BuildGroups.py --clean --verbose --use_MP --cpus 10 ./ ../strainlist.txt ncyclers_21022018_pyp

PropagateGroups.py ./ prop_strainlist.txt ncyclers_21022018_pyp/

IdentifyOrthologs.py --threshold 0.95 ncyclers_21022018_pyp/ ncyclers_21022018_ortho