# ============================================================================
# Dream Server Windows -- local LLM endpoint helpers
# ============================================================================
# Part of: installers/windows/lib/
# Purpose: Parse .env safely and resolve the active local LLM endpoint across
#          Docker-backed NVIDIA/CPU installs and native AMD backends.
# ============================================================================

function Get-WindowsDreamEnvMap {
    <#
    .SYNOPSIS
        Parse the generated .env file without executing it.
    #>
    param(
        [string]$InstallDir = $script:DS_INSTALL_DIR,
        [string]$Path = ""
    )

    if ([string]::IsNullOrWhiteSpace($Path)) {
        if ([string]::IsNullOrWhiteSpace($InstallDir)) {
            return @{}
        }
        $Path = Join-Path $InstallDir ".env"
    }

    $result = @{}
    if (-not (Test-Path $Path)) { return $result }

    Get-Content $Path | ForEach-Object {
        $line = $_.Trim()
        if ($line -match "^#" -or $line -eq "") { return }
        if ($line -match "^([A-Za-z_][A-Za-z0-9_]*)=(.*)$") {
            $key = $Matches[1]
            $val = $Matches[2].Trim('"').Trim("'")
            $result[$key] = $val
        }
    }

    return $result
}

function Get-WindowsDreamEnvValue {
    <#
    .SYNOPSIS
        Read the first populated value from a parsed .env hashtable.
    #>
    param(
        [hashtable]$EnvMap,
        [string[]]$Keys,
        [string]$Default = ""
    )

    foreach ($key in $Keys) {
        if ($EnvMap.ContainsKey($key)) {
            $value = [string]$EnvMap[$key]
            if (-not [string]::IsNullOrWhiteSpace($value)) {
                return $value
            }
        }
    }

    return $Default
}

function Get-WindowsLocalLlmEndpoint {
    <#
    .SYNOPSIS
        Resolve the active local LLM endpoint for native AMD and Docker installs.
    .OUTPUTS
        @{ Name; Backend; Port; ApiBasePath; HealthUrl; BaseUrl; ChatCompletionsUrl }
    #>
    param(
        [string]$InstallDir = $script:DS_INSTALL_DIR,
        [hashtable]$EnvMap = $null,
        [string]$GpuBackend = "",
        [string]$NativeBackend = "",
        [switch]$UseLemonade,
        [switch]$CloudMode
    )

    if ($null -eq $EnvMap) {
        $EnvMap = Get-WindowsDreamEnvMap -InstallDir $InstallDir
    }

    $resolvedNativeBackend = $NativeBackend
    if ([string]::IsNullOrWhiteSpace($resolvedNativeBackend)) {
        $resolvedNativeBackend = ""
    } else {
        $resolvedNativeBackend = $resolvedNativeBackend.ToLowerInvariant()
    }

    $resolvedGpuBackend = $GpuBackend
    if ([string]::IsNullOrWhiteSpace($resolvedGpuBackend)) {
        $resolvedGpuBackend = Get-WindowsDreamEnvValue -EnvMap $EnvMap -Keys @("GPU_BACKEND") -Default ""
    }
    if (-not [string]::IsNullOrWhiteSpace($resolvedGpuBackend)) {
        $resolvedGpuBackend = $resolvedGpuBackend.ToLowerInvariant()
    }

    $llmBackend = Get-WindowsDreamEnvValue -EnvMap $EnvMap -Keys @("LLM_BACKEND") -Default "llama-server"
    if (-not [string]::IsNullOrWhiteSpace($llmBackend)) {
        $llmBackend = $llmBackend.ToLowerInvariant()
    }

    if ($UseLemonade -or $resolvedNativeBackend -eq "lemonade" -or $llmBackend -eq "lemonade") {
        return @{
            Name = "LLM (Lemonade)"
            Backend = "lemonade"
            Port = "$($script:LEMONADE_PORT)"
            ApiBasePath = "/api/v1"
            HealthUrl = $script:LEMONADE_HEALTH_URL
            BaseUrl = "http://localhost:$($script:LEMONADE_PORT)/api/v1"
            ChatCompletionsUrl = "http://localhost:$($script:LEMONADE_PORT)/api/v1/chat/completions"
        }
    }

    if ($resolvedNativeBackend -eq "llama-server" -or (-not $CloudMode -and $resolvedGpuBackend -eq "amd")) {
        return @{
            Name = "LLM (llama-server)"
            Backend = "native-llama-server"
            Port = "8080"
            ApiBasePath = "/v1"
            HealthUrl = "http://localhost:8080/health"
            BaseUrl = "http://localhost:8080/v1"
            ChatCompletionsUrl = "http://localhost:8080/v1/chat/completions"
        }
    }

    $port = Get-WindowsDreamEnvValue -EnvMap $EnvMap -Keys @("OLLAMA_PORT", "LLAMA_SERVER_PORT") -Default "11434"
    $apiBasePath = Get-WindowsDreamEnvValue -EnvMap $EnvMap -Keys @("LLM_API_BASE_PATH") -Default "/v1"
    if ($apiBasePath -notmatch "^/") {
        $apiBasePath = "/$apiBasePath"
    }

    return @{
        Name = "LLM (llama-server)"
        Backend = "docker-llama-server"
        Port = $port
        ApiBasePath = $apiBasePath
        HealthUrl = "http://localhost:${port}/health"
        BaseUrl = "http://localhost:${port}${apiBasePath}"
        ChatCompletionsUrl = "http://localhost:${port}${apiBasePath}/chat/completions"
    }
}
