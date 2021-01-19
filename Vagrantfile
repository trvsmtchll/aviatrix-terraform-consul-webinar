Vagrant.configure("2") do |config|
  config.vm.hostname = 'aviatrix-vm'
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.provider :virtualbox do |vb|
		vb.name = 'aviatrix-vm'
		vb.customize ['modifyvm', :id, '--memory', '1024', '--cpus', '1']
  end
  
  # config.vm.synced_folder "../terraform", "/build"

  config.vm.provision "shell", inline: <<-SHELL
    #if [ "#{ENV["AWS_SECRET_ACCESS_KEY"]}" = "" ]; then
    #  echo "Missing: AWS_SECRET_ACCESS_KEY";
    #  exit 1;
    #fi;
    #if [ "#{ENV["AWS_ACCESS_KEY_ID"]}" = "" ]; then
    #  echo "Missing: AWS_ACCESS_KEY_ID";
    #  exit 1;
    #fi;
     sudo apt-get update -y
     sudo apt-get install -y bc git jq python-pip zip unzip wget software-properties-common;
     sudo add-apt-repository ppa:deadsnakes/ppa;
     sudo apt-get update -y
     sudo apt-get install -y python3.8
     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
     unzip awscliv2.zip 
     sudo ./aws/install
     echo "Setting up AWS...";
     mkdir -p /home/vagrant/.aws;
     echo '[default]' >> /home/vagrant/.aws/credentials;
     echo 'aws_secret_access_key = #{ENV["AWS_SECRET_ACCESS_KEY"]}' >> /home/vagrant/.aws/credentials;
     echo 'aws_access_key_id = #{ENV["AWS_ACCESS_KEY_ID"]}' >> /home/vagrant/.aws/credentials;
     echo '[default]' >> /home/vagrant/.aws/config;
     echo 'region = us-east-1' >> /home/vagrant/.aws/config;
     echo 'TF_VAR_aws_secret_access_key=#{ENV["AWS_SECRET_ACCESS_KEY"]}' >> /home/vagrant/aws.env;
     echo 'TF_VAR_aws_access_key_id=#{ENV["AWS_ACCESS_KEY_ID"]}' >> /home/vagrant/aws.env;
     sudo chown vagrant:vagrant /home/vagrant/aws.env;
     rm /home/vagrant/awscliv2.zip
     curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
     wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip
     sudo unzip /home/vagrant/terraform_0.12.29_linux_amd64.zip -d /usr/local/bin/
     rm /home/vagrant/terraform_0.12.29_linux_amd64.zip
     echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
     sudo apt-get install -y apt-transport-https ca-certificates gnupg
     curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
     sudo apt-get update -y  && sudo apt-get install -y google-cloud-sdk
     echo "********* Aviatrix Multi-Cloud Development VM *********"
     echo ""
     echo "Installed packages.."
     echo ""  
     echo "Terraform version:";
		 terraform -v;
     echo "AWS CLI version";
     aws --version;
     echo "Azure CLI version";
     az --version;
     echo "Google Cloud SDK version";
     gcloud -v;
     SHELL
end
