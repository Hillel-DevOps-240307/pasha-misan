#!/bin/bash
max_dump_count=7
region="eu-central-1"
bucket_param_name="/db/dump_bucket_name"
name_prefix="backup"
bucket_folder="flask_db"
backup_dir="/tmp/dump"
tar_file_path="${backup_dir}/${name_prefix}_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"

mkdir $backup_dir

sudo /usr/bin/mysqldump flask_db > "$backup_dir/$name_prefix.sql"
tar -zcvf "$tar_file_path" -C $backup_dir $name_prefix.sql

bucket_name=$(aws ssm get-parameter --name "$bucket_param_name" --region "$region" --query "Parameter.Value" --output text)
aws s3 cp "$tar_file_path" "s3://${bucket_name}/${bucket_folder}/"

rm -rf $backup_dir

count=0
files=$(aws s3api list-objects --bucket "$bucket_name" --prefix "$bucket_folder/$name_prefix" --query 'reverse(sort_by(Contents, &LastModified))[].[Key]' --output text)
for file in $files; do
    ((count++))

    if [ $count -gt $max_dump_count ]; then
        aws s3 rm "s3://$bucket_name/$file"
    fi
done
