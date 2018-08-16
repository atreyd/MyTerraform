data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # get master user_data
  part {
    filename     = "master.sh"
    content_type = "text/part-handler"
    content      = "${data.template_file.config.rendered}"
  }
}