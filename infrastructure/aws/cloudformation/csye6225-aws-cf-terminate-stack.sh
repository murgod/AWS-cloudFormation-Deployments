echo "Enter the stack name to be deleted"
read s_name

#aws cloudformation list-stacks --stack-status-filter CREATE_IN_PROGRESS CREATE_COMPLETE ROLLBACK_IN_PROGRESS ROLLBACK_FAILED ROLLBACK_COMPLETE DELETE_IN_PROGRESS DELETE_FAILED UPDATE_IN_PROGRESS UPDATE_COMPLETE_CLEANUP_IN_PROGRESS UPDATE_COMPLETE UPDATE_ROLLBACK_IN_PROGRESS UPDATE_ROLLBACK_FAILED UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS UPDATE_ROLLBACK_COMPLETE REVIEW_IN_PROGRESS --query "StackSummaries[*].StackName --stack-name $s_name"
StackList=$(aws cloudformation list-stack-resources --stack-name $s_name)

if [ -z $StackList ] ; then
  echo "$Stack_Name Stack does not exist"
  exit 1
fi

#StackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE||CREATE_IN_PROGRESS||REVIEW_IN_PROGRESS||DELETE_IN_PROGRESS||DELETE_FAILED||UPDATE_IN_PROGRESS||DELETE_COMPLETE)
echo "$StackList"

aws cloudformation delete-stack --stack-name $s_name
aws cloudformation wait stack-delete-complete --stack-name $s_name

echo "$Stack_Name Stack is deleted successfully"
