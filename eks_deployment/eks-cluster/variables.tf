#
# BUG FIX : https://github.com/terraform-aws-modules/terraform-aws-eks/pull/750
# wait_for_cluster_cmd = "until wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null; do sleep 4; done"
#
variable "wait_for_cluster_cmd" { 
   description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT" 
   type        = string 
  #default     = "until curl -k -s $ENDPOINT/healthz >/dev/null; do sleep 4; done" 
   default     = "until wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null; do sleep 4; done"
 }
