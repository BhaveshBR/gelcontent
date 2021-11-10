
dt=$(date +%d-%b-%H_%M)
folderpath=/Public

# get the id of the folder
folderid=$(./sas-viya --output json folders show --path $folderpath | jq -r '.["id"]')
echo Exporting $folderpath id is $folderid

# export the folder to a package then get the package id
./sas-viya --output text transfer export -u /folders/folders/$folderid -n "$dt-$folderid"
exportid=$(./sas-viya --output json transfer list -n "$dt-$folderid"  | jq -r '.items[]["id"]')

#download the package to the shared directory
./sas-viya transfer download --file /gelcontent/batch/packages/public_$dt.json --id $exportid

echo "Packages exported to /gelcontent/batch/packages/"
ls -al  /gelcontent/batch/packages/

