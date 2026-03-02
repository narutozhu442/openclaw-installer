#!/bin/bash
# OpenClaw 一键安装脚本 - 多免费模型版本
# 支持：Linux / macOS / WSL
# 自动配置：联通云 / Coze / 硅基流动 / GitHub Models

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }

clear
echo "========================================"
echo "  🦕 OpenClaw 一键安装器"
echo "  多免费模型版本"
echo "========================================"
echo ""

# 检查系统
info "检测系统环境..."
OS=$(uname -s)
info "系统: $OS"

# 检查依赖
if ! command -v curl &> /dev/null; then
    error "curl 未安装，请先安装 curl"
    exit 1
fi

# 检查 Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -ge 22 ]; then
        success "Node.js 版本符合要求 ($(node -v))"
    else
        warn "Node.js 版本过低，正在升级..."
        curl -fsSL https://deb.nodesource.com/setup_22.x | bash - 2>/dev/null || true
        apt-get install -y nodejs 2>/dev/null || brew install node@22 2>/dev/null || true
    fi
else
    info "正在安装 Node.js 22..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - 2>/dev/null || true
    apt-get install -y nodejs 2>/dev/null || brew install node 2>/dev/null || true
fi

# 安装 OpenClaw
info "正在安装 OpenClaw..."
if command -v openclaw &> /dev/null; then
    warn "OpenClaw 已安装: $(openclaw --version)"
    read -p "是否重新安装? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm uninstall -g openclaw 2>/dev/null || true
        npm install -g openclaw
    fi
else
    npm install -g openclaw
fi

if ! command -v openclaw &> /dev/null; then
    error "OpenClaw 安装失败"
    exit 1
fi
success "OpenClaw 安装成功!"

# 创建配置目录
CONFIG_DIR="$HOME/.openclaw/agents/main/agent"
mkdir -p "$CONFIG_DIR"

# 选择模型配置
echo ""
echo "========================================"
echo "  🎯 选择模型配置方案"
echo "========================================"
echo ""
echo "1) GitHub Models - 最简单，有GitHub账号即可"
echo "2) 硅基流动(SiliconFlow) - 国内访问快，14元体验金"
echo "3) Coze(扣子) - 字节跳动，Kimi模型"
echo "4) 联通云 - 5款免费模型，需实名认证"
echo "5) 全部配置 - 包含以上所有(推荐)"
echo ""
read -p "请选择 [1-5]: " choice

case $choice in
    1)
        info "配置 GitHub Models..."
        cat > "$CONFIG_DIR/models.json" << 'EOF'
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
EOF
        success "GitHub Models 配置完成"
        PROVIDER="GitHub"
        URL="https://github.com/settings/tokens"
        ;;
    2)
        info "配置 硅基流动..."
        cat > "$CONFIG_DIR/models.json" << 'EOF'
{
  "providers": {
    "siliconflow": {
      "baseUrl": "https://api.siliconflow.cn/v1",
      "apiKey": "sk-YOUR_SILICONFLOW_KEY_HERE",
      "api": "openai-completions",
      "models": [
        {"id": "deepseek-ai/DeepSeek-V3", "name": "DeepSeek V3", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 64000, "maxTokens": 8192, "api": "openai-completions"},
        {"id": "Qwen/Qwen2.5-72B-Instruct", "name": "Qwen2.5 72B", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 32000, "maxTokens": 4096, "api": "openai-completions"}
      ]
    }
  }
}
EOF
        success "硅基流动配置完成"
        PROVIDER="硅基流动"
        URL="https://siliconflow.cn"
        ;;
    3)
        info "配置 Coze..."
        cat > "$CONFIG_DIR/models.json" << 'EOF'
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
EOF
        success "Coze 配置完成"
        PROVIDER="Coze"
        URL="https://www.coze.cn"
        ;;
    4)
        info "配置 联通云..."
        cat > "$CONFIG_DIR/models.json" << 'EOF'
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
EOF
        success "联通云配置完成"
        PROVIDER="联通云"
        URL="https://www.cucloud.cn"
        ;;
    5|*)
        info "配置全部免费模型..."
        cat > "$CONFIG_DIR/models.json" << 'EOF'
{
  "providers": {
    "github": {
      "baseUrl": "https://models.inference.ai.azure.com",
      "apiKey": "ghp_YOUR_GITHUB_TOKEN",
      "api": "openai-completions",
      "models": [
        {"id": "gpt-4o-mini", "name": "GPT-4o Mini", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 128000, "maxTokens": 4096, "api": "openai-completions"},
        {"id": "deepseek-chat", "name": "DeepSeek Chat", "reasoning": false, "input": ["text"], "cost": {"input": 0, "output": 0}, "contextWindow": 64000, "maxTokens": 4096, "api": "openai-completions"}
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
EOF
        success "全模型配置完成"
        PROVIDER="多提供商"
        URL="详见文档"
        ;;
esac

# 完成提示
echo ""
echo "========================================"
echo -e "${GREEN}🎉 OpenClaw 安装完成!${NC}"
echo "========================================"
echo ""
echo "📁 配置文件: $CONFIG_DIR/models.json"
echo ""
echo "📝 下一步:"
echo ""
if [ "$choice" = "5" ]; then
    echo "你选择了全模型配置，需要填写多个 API Key:"
    echo ""
    echo "1. GitHub Token: https://github.com/settings/tokens"
    echo "2. 硅基流动: https://siliconflow.cn"
    echo "3. Coze: https://www.coze.cn"
    echo ""
    echo "填写任意一个即可使用，填写多个可自动切换!"
else
    echo "1. 获取 $PROVIDER API Key:"
    echo "   $URL"
    echo ""
    echo "2. 编辑配置文件填入 API Key:"
    echo "   nano $CONFIG_DIR/models.json"
fi

echo ""
echo "🚀 启动命令: openclaw gateway start"
echo "🌐 访问地址: http://127.0.0.1:18789"
echo ""
echo "📚 更多帮助: openclaw --help"
echo ""
