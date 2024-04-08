# run Rscript src/scripts/clean_ind_bulk.R.R ./data/original/contributions/CampaignFin12/indivs12.txt
# for all files in ./data/original/contributions/CampaignFin*/indivs*.txt 

echo "Cleaning individual contributions"

for file in ./data/original/contributions/CampaignFin*/indivs*.txt
do
  echo "Cleaning $file"

  # check if file exists in ./data/cleaned/semi_clean/indivs*.csv
  # if it does, skip cleaning
  if [ -f ./data/cleaned/semi_clean/$(basename $file .txt).csv ]; then
    echo "File already exists, skipping"
    continue
  fi

  Rscript src/scripts/clean_ind_bulk.R.R $file
done

# print separator
echo "\n\n"
echo "----------------------------------------"
echo "Cleaning PACs"

for file in ./data/original/contributions/CampaignFin*/pacs*.txt
do
  echo "Cleaning $file"

  # check if file exists in ./data/cleaned/semi_clean/pacs*.csv
  # if it does, skip cleaning
  if [ -f ./data/cleaned/semi_clean/$(basename $file .txt).csv ]; then
    echo "File already exists, skipping"
    continue
  fi

  Rscript src/scripts/clean_pac_bulk.R $file
done

# run this in terminal to run bulk clean process: ./src/scripts/run_build_clean.sh