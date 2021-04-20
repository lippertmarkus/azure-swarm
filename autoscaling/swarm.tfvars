additionalPostScriptMgr = "https://raw.githubusercontent.com/lippertmarkus/azure-swarm-autoscaling/master/autoscaling/additionalPostScriptMgr.ps1"
additionalPreScriptWorker = "https://raw.githubusercontent.com/lippertmarkus/azure-swarm-autoscaling/master/autoscaling/additionalPreScriptWorker.ps1"
workerVmssSettings = {
    size       = "Standard_E2ds_v4"
    number     = 2
    sku        = "datacenter-core-2004-with-containers-smalldisk"
    version    = "latest"
    diskSizeGb = 512 # probably also adjust line 4
}
managerVmSettings = {
    size     = "Standard_D2s_v3"
    useThree = false
    sku      = "datacenter-core-2004-with-containers-smalldisk"
    version  = "latest"
}
eMail = "markus.lippert@cosmoconsult.com"