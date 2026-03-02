# OpenClaw 一键安装脚本 (Windows PowerShell)
# 支持：Windows 10/11
# 自动配置：GitHub Models / 硅基流动 / Coze / 联通云

param(
    [switch]$SkipNodeCheck,
    [switch]$ForceReinstall
)

# 颜色输出函数
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[✓] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[!] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[✗] $msg" -ForegroundColor Red }

Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🦕 OpenClaw Windows 安装器" -ForegroundColor Cyan
Write-Host "  多免费模型版本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Warn "建议以管理员身份运行以获得最佳体验"
}

# 检测系统
Write-Info "检测系统环境..."
$OS = (Get-CimInstance Win32_OperatingSystem).Caption
Write-Info "系统: $OS"

# 检查/安装 Node.js
if (-not $SkipNodeCheck) {
    Write-Info "检查 Node.js..."
    try {
        $nodeVersion = node -v 2>$null
        if ($nodeVersion) {
            $majorVersion = [int]($nodeVersion -replace 'v' -split '\.')[0]
            if ($majorVersion -ge 22) {
                Write-Success "Node.js 版本符合要求 ($nodeVersion)"
            } else {
                Write-Warn "Node.js 版本过低，需要 22+"
                Write-Info "请从 https://nodejs.org 下载安装 Node.js 22 LTS"
                pause
                exit 1
            }
        } else {
            throw "Node.js not found"
        }
    } catch {
        Write-Warn "Node.js 未安装"
        Write-Info "请从 https://nodejs.org 下载安装 Node.js 22 LTS"
        Write-Info "安装完成后重新运行此脚本"
        pause
        exit 1
    }
}

# 安装 OpenClaw
Write-Info "正在安装 OpenClaw..."
try {
    $existingVersion = openclaw --version 2>$null
    if ($existingVersion -and -not $ForceReinstall) {
        Write-Warn "OpenClaw 已安装: $existingVersion"
        $reinstall = Read-Host "是否重新安装? (y/N)"
        if ($reinstall -eq 'y' -or $reinstall -eq 'Y') {
            npm uninstall -g openclaw 2>$null
            npm install -g openclaw
        }
    } else {
        npm install -g openclaw
    }
} catch {
    npm install -g openclaw
}

# 验证安装
try {
    $version = openclaw --version 2>$null
    if ($version) {
        Write-Success "OpenClaw 安装成功: $version"
    } else {
        throw "Installation failed"
    }
} catch {
    Write-Error "OpenClaw 安装失败"
    Write-Info "请尝试手动安装: npm install -g openclaw"
    pause
    exit 1
}

# 创建配置目录
$configDir = "$env:USERPROFILE\.openclaw\agents\main\agent"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null

# 选择模型配置
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  🎯 选择模型配置方案" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1) GitHub Models - 最简单，有GitHub账号即可"
Write-Host "2) 硅基流动(SiliconFlow) - 国内访问快，14元体验金"
Write-Host "3) Coze(扣子) - 字节跳动，Kimi模型"
Write-Host "4) 联通云 - 5款免费模型，需实名认证"
Write-Host "5) 全部配置 - 包含以上所有(推荐)"
Write-Host ""
$choice = Read-Host "请选择 [1-5]"

switch ($choice) {
    "1" {
        Write-Info "配置 GitHub Models..."
        $configContent = @'
{
  "providers": {
    "github": {
      "baseUrl": "https://models.inference.ai.azure.com",
      "apiKey": "ghp_YOUR_GITHUB_TOKEN_HERE",
      "api": "openai-completions",
      "models": [
        {"id": "gpt-4o-mini", "name": "GPT-4o Mini", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 128000, "maxTokens": 4096, "api": "openai-completions"},
        {"id": "deepseek-chat", "name": "DeepSeek Chat", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 64000, "maxTokens": 4096, "api": "openai-completions"}
      ]
    }
  }
}
'@
        $configContent | Out-File -FilePath "$configDir\models.json" -Encoding UTF8
        Write-Success "GitHub Models 配置完成"
        $PROVIDER = "GitHub"
        $URL = "https://github.com/settings/tokens"
    }
    "2" {
        Write-Info "配置 硅基流动..."
        $configContent = @'
{
  "providers": {
    "siliconflow": {
      "baseUrl": "https://api.siliconflow.cn/v1",
      "apiKey": "sk-YOUR_SILICONFLOW_KEY_HERE",
      "api": "openai-completions",
      "models": [
        {"id": "deepseek-ai/DeepSeek-V3", "name": "DeepSeek V3", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 64000, "maxTokens": 8192, "api": "openai-completions"}
      ]
    }
  }
}
'@
        $configContent | Out-File -FilePath "$configDir\models.json" -Encoding UTF8
        Write-Success "硅基流动配置完成"
        $PROVIDER = "硅基流动"
        $URL = "https://siliconflow.cn"
    }
    "3" {
        Write-Info "配置 Coze..."
        $configContent = @'
{
  "providers": {
    "coze": {
      "baseUrl": "https://integration.coze.cn/api/v3",
      "apiKey": "YOUR_COZE_API_KEY_HERE",
      "api": "openai-completions",
      "models": [
        {"id": "kimi-k2-5-260127", "name": "Kimi K2.5", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 256000, "maxTokens": 8192, "api": "openai-completions"}
      ]
    }
  }
}
'@
        $configContent | Out-File -FilePath "$configDir\models.json" -Encoding UTF8
        Write-Success "Coze 配置完成"
        $PROVIDER = "Coze"
        $URL = "https://www.coze.cn"
    }
    "4" {
        Write-Info "配置 联通云..."
        $configContent = @'
{
  "providers": {
    "cucloud": {
      "baseUrl": "https://aigw-gzgy2.cucloud.cn:8443/v1",
      "apiKey": "sk-YOUR_CUCLOUD_KEY_HERE",
      "api": "openai-completions",
      "models": [
        {"id": "Qwen3.5-397B-A17B", "name": "Qwen 3.5 397B", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 128000, "maxTokens": 8192, "api": "openai-completions"},
        {"id": "deepseek-ai/DeepSeek-V3", "name": "DeepSeek V3", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 64000, "maxTokens": 8192, "api": "openai-completions"},
        {"id": "DeepSeek-V3.1", "name": "DeepSeek V3.1", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 64000, "maxTokens": 8192, "api": "openai-completions"},
        {"id": "Qwen3-235B-A22B", "name": "Qwen3 235B", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 128000, "maxTokens": 8192, "api": "openai-completions"},
        {"id": "glm-5", "name": "GLM-5", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 128000, "maxTokens": 8192, "api": "openai-completions"}
      ]
    }
  }
}
'@
        $configContent | Out-File -FilePath "$configDir\models.json" -Encoding UTF8
        Write-Success "联通云配置完成"
        $PROVIDER = "联通云"
        $URL = "https://www.cucloud.cn"
    }
    default {
        Write-Info "配置全部免费模型..."
        $configContent = @'
{
  "providers": {
    "github": {
      "baseUrl": "https://models.inference.ai.azure.com",
      "apiKey": "ghp_YOUR_GITHUB_TOKEN",
      "api": "openai-completions",
      "models": [
        {"id": "gpt-4o-mini", "name": "GPT-4o Mini", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 128000, "maxTokens": 4096, "api": "openai-completions"}
      ]
    },
    "siliconflow": {
      "baseUrl": "https://api.siliconflow.cn/v1",
      "apiKey": "sk-YOUR_SILICONFLOW_KEY",
      "api": "openai-completions",
      "models": [
        {"id": "deepseek-ai/DeepSeek-V3", "name": "DeepSeek V3(硅基)", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 64000, "maxTokens": 8192, "api": "openai-completions"}
      ]
    },
    "coze": {
      "baseUrl": "https://integration.coze.cn/api/v3",
      "apiKey": "YOUR_COZE_KEY",
      "api": "openai-completions",
      "models": [
        {"id": "kimi-k2-5-260127", "name": "Kimi K2.5", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 256000, "maxTokens": 8192, "api": "openai-completions"}
      ]
    }
  }
}
'@
        $configContent | Out-File -FilePath "$configDir\models.json" -Encoding UTF8
        Write-Success "全模型配置完成"
        $PROVIDER = "多提供商"
        $URL = "详见文档"
    }
}

# 完成提示
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  🎉 OpenClaw 安装完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📁 配置文件: $configDir\models.json"
Write-Host ""
Write-Host "📝 下一步:"
Write-Host ""
if ($choice -eq "5") {
    Write-Host "你选择了全模型配置，需要填写多个 API Key:"
    Write-Host ""
    Write-Host "1. GitHub Token: https://github.com/settings/tokens"
    Write-Host "2. 硅基流动: https://siliconflow.cn"
    Write-Host "3. Coze: https://www.coze.cn"
    Write-Host ""
    Write-Host "填写任意一个即可使用，填写多个可自动切换!"
} else {
    Write-Host "1. 获取 $PROVIDER API Key:"
    Write-Host "   $URL"
    Write-Host ""
    Write-Host "2. 编辑配置文件填入 API Key:"
    Write-Host "   notepad $configDir\models.json"
}
Write-Host ""
Write-Host "🚀 启动命令: openclaw gateway start"
Write-Host "🌐 访问地址: http://127.0.0.1:18789"
Write-Host ""
Write-Host "📚 更多帮助: openclaw --help"
Write-Host ""

pause
