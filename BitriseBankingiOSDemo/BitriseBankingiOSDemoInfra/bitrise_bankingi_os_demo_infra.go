package main

import (
	"os"

	"github.com/aws/aws-cdk-go/awscdk/v2"
	"github.com/aws/aws-cdk-go/awscdk/v2/awsiam"
	"github.com/aws/aws-cdk-go/awscdk/v2/awss3"
	"github.com/aws/aws-cdk-go/awscdk/v2/awssecretsmanager"

	"github.com/aws/constructs-go/constructs/v10"
	"github.com/aws/jsii-runtime-go"
)

type BitriseBankingiOsDemoInfraStackProps struct {
	awscdk.StackProps
}

func NewBitriseBankingiOsDemoInfraStack(scope constructs.Construct, id string, props *BitriseBankingiOsDemoInfraStackProps) awscdk.Stack {
	var sprops awscdk.StackProps
	if props != nil {
		sprops = props.StackProps
	}
	stack := awscdk.NewStack(scope, &id, &sprops)

	// Create S3 bucket for storing iOS signing certificates
	bucket := awss3.NewBucket(stack, jsii.String("bitrise-banking-ios-demo-signing-certs"), &awss3.BucketProps{
		BucketName:        jsii.String("bitrise-banking-ios-demo-signing-certs"),
		Versioned:         jsii.Bool(false),
		AccessControl:     awss3.BucketAccessControl_BUCKET_OWNER_FULL_CONTROL,
		Encryption:        awss3.BucketEncryption_S3_MANAGED,
		BlockPublicAccess: awss3.BlockPublicAccess_BLOCK_ALL(),
		RemovalPolicy:     awscdk.RemovalPolicy_DESTROY,
	})

	// Add tags to bucket
	awscdk.Tags_Of(bucket).Add(jsii.String("team"), jsii.String("build-services"), nil)
	awscdk.Tags_Of(bucket).Add(jsii.String("project"), jsii.String("demo"), nil)
	awscdk.Tags_Of(bucket).Add(jsii.String("system"), jsii.String("bucket"), nil)

	// Secret Manager secret for Git username
	secretGitUsername := awssecretsmanager.NewSecret(stack, jsii.String("BitriseDemoGitUsername"), &awssecretsmanager.SecretProps{
		SecretName:  jsii.String("BitriseDemoGitUsername"),
		Description: jsii.String("This is an example secret for Bitrise CI on AWS"),
	})
	awscdk.Tags_Of(secretGitUsername).Add(jsii.String("team"), jsii.String("build-services"), nil)
	awscdk.Tags_Of(secretGitUsername).Add(jsii.String("project"), jsii.String("demo"), nil)
	awscdk.Tags_Of(secretGitUsername).Add(jsii.String("system"), jsii.String("secret"), nil)

	// Secret Manager secret for Git password
	secretGitPassword := awssecretsmanager.NewSecret(stack, jsii.String("BitriseDemoGitPassword"), &awssecretsmanager.SecretProps{
		SecretName:  jsii.String("BitriseDemoGitPassword"),
		Description: jsii.String("This is an example secret for Bitrise CI on AWS"),
	})
	awscdk.Tags_Of(secretGitPassword).Add(jsii.String("team"), jsii.String("build-services"), nil)
	awscdk.Tags_Of(secretGitPassword).Add(jsii.String("project"), jsii.String("demo"), nil)
	awscdk.Tags_Of(secretGitPassword).Add(jsii.String("system"), jsii.String("secret"), nil)

	// IAM role for EC2 Mac build instance profile
	role := awsiam.NewRole(stack, jsii.String("BitriseDemoEC2Role"), &awsiam.RoleProps{
		RoleName:    jsii.String("BitriseDemoEC2Role"),
		AssumedBy:   awsiam.NewServicePrincipal(jsii.String("ec2.amazonaws.com"), nil),
		Description: jsii.String("Role assumed Demo EC2 Mac builder nodes"),
	})
	awsiam.NewInstanceProfile(stack, jsii.String("BitriseDemoEC2InstanceProfile"), &awsiam.InstanceProfileProps{
		InstanceProfileName: jsii.String("BitriseDemoEC2InstanceProfile"),
		Role:                role,
	})

	secretGitUsername.GrantRead(role, nil)
	secretGitPassword.GrantRead(role, nil)
	role.AddManagedPolicy(awsiam.ManagedPolicy_FromAwsManagedPolicyName(jsii.String("AWSDeviceFarmFullAccess")))
	role.AddManagedPolicy(awsiam.ManagedPolicy_FromAwsManagedPolicyName(jsii.String("AWSCloudFormationFullAccess")))
	role.AddManagedPolicy(awsiam.ManagedPolicy_FromAwsManagedPolicyName(jsii.String("SecretsManagerReadWrite")))
	role.AddToPolicy(awsiam.NewPolicyStatement(&awsiam.PolicyStatementProps{
		Actions:   &[]*string{jsii.String("sts:AssumeRole")},
		Resources: &[]*string{jsii.String("arn:aws:iam::*:role/cdk-*")},
	}))
	bucket.GrantRead(role, nil)

	awscdk.Tags_Of(role).Add(jsii.String("team"), jsii.String("build-services"), nil)
	awscdk.Tags_Of(role).Add(jsii.String("project"), jsii.String("demo"), nil)
	awscdk.Tags_Of(role).Add(jsii.String("system"), jsii.String("iam"), nil)

	return stack
}

func main() {
	defer jsii.Close()

	app := awscdk.NewApp(nil)

	NewBitriseBankingiOsDemoInfraStack(app, "BitriseBankingiOsDemoInfraStack", &BitriseBankingiOsDemoInfraStackProps{
		awscdk.StackProps{
			Env: env(),
		},
	})

	app.Synth(nil)
}

// env determines the AWS environment (account+region) in which our stack is to
// be deployed. For more information see: https://docs.aws.amazon.com/cdk/latest/guide/environments.html
func env() *awscdk.Environment {
	return &awscdk.Environment{
		Account: jsii.String(os.Getenv("CDK_DEFAULT_ACCOUNT")),
		Region:  jsii.String(os.Getenv("CDK_DEFAULT_REGION")),
	}
}
