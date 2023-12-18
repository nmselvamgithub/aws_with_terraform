resource "aws_db_subnet_group" "nmsDBSubnetgroup" {
    name = "nms-db-subnet-group"
    subnet_ids = [
        var.nms_private_subnets[0].id,
        var.nms_private_subnets[1].id
    ]
    tags = {
    Name = "nmsSubnetGroup"
    Project = "nmsProject" 
}
}

resource "aws_security_group" "nmsDBSecuritygropup" {
    name = "nms-DB-Security-gropup"
    vpc_id = var.nms_vpc_id

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = [
            var.nms_private_subnet_cidr[0],
            var.nms_private_subnet_cidr[1]
            ] 
    }
    tags = {
        Name = "nmsDBSecuritygropup"
        Project = "nmsProject"
            }
}

resource "aws_db_instance" "nmsRDS" {
    availability_zone = var.db_az
    db_subnet_group_name = aws_db_subnet_group.nmsDBSubnetgroup.name
    vpc_security_group_ids = [aws_security_group.nmsDBSecuritygropup.id]
    allocated_storage = 20
    storage_type = "standard"
    engine = "postgres"
    engine_version = "12"
    instance_class = "db.t2.micro"
    username = var.db_user_name 
    password = var.db_user_password
    skip_final_snapshot = true
    tags = {
      Name = "nmsRDS"
      Project = "nmsProject"

    }

  
}