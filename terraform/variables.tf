# provider

variable "credentials" {
  description = "GCP에 액세스하기 위한 json 파일"
  default = "/Users/dodo/de-study/kafka-cluster/private/kafka-cluster.json"
}

variable "project" {
  description = "프로젝트 ID"
  default = "gentle-presence-446707-m1" 
}

variable "region" {
  default = "asia-northeast3" 
}


# main

variable "zone" {
  default = "asia-northeast3-b" 
}