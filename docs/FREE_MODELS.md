# 免费模型配置指南

## 支持的免费模型提供商

本安装包支持以下免费模型提供商，你可以根据需要选择：

### 1️⃣ 联通云 (CuCloud) - 推荐
- **网址**: https://www.cucloud.cn
- **免费额度**: 新用户充足免费额度
- **模型**: Qwen3.5, DeepSeek-V3, GLM-5 等5款
- **特点**: 国内访问快，无需翻墙
- **申请难度**: ⭐⭐⭐（需要实名认证）

### 2️⃣ Coze (扣子) - 推荐
- **网址**: https://www.coze.cn
- **免费额度**:  generous 免费额度
- **模型**: Kimi K2.5, GLM-4, DeepSeek 等
- **特点**: 字节跳动出品，稳定可靠
- **申请难度**: ⭐⭐（简单注册即可）

### 3️⃣ 硅基流动 (SiliconFlow)
- **网址**: https://siliconflow.cn
- **免费额度**: 14元体验金 + 每日免费额度
- **模型**: DeepSeek, Qwen, Llama 等
- **特点**: 模型全，价格实惠
- **申请难度**: ⭐（极简单）

### 4️⃣ GitHub Models - 最简单
- **网址**: https://github.com/marketplace/models
- **免费额度**: 个人开发者免费 tier
- **模型**: GPT-4o-mini, DeepSeek, Phi 等
- **特点**: 有 GitHub 账号即可用
- **申请难度**: ⭐（已有账号直接用）

### 5️⃣ OpenRouter
- **网址**: https://openrouter.ai
- **免费额度**: 部分模型免费
- **模型**: 聚合多平台模型
- **特点**: 一个接口调用多家模型
- **申请难度**: ⭐（简单注册）

---

## 快速配置

### 方案A：GitHub Models（最快，30秒搞定）

1. 确保你有 GitHub 账号
2. 访问 https://github.com/settings/tokens
3. 生成一个 Token（不需要特殊权限）
4. 编辑 `models.json`，填入 GitHub Token
5. 完成！

### 方案B：硅基流动（推荐国内用户）

1. 访问 https://siliconflow.cn
2. 用手机号注册
3. 获取 API Key
4. 编辑 `models.json`，填入 Key

### 方案C：Coze

1. 访问 https://www.coze.cn
2. 用抖音/飞书账号登录
3. 创建 Bot，获取 API Key
4. 编辑 `models.json`

---

## models.json 配置模板

### 使用 GitHub Models（最简单）

```json
{
  "providers": {
    "github": {
      "baseUrl": "https://models.inference.ai.azure.com",
      "apiKey": "ghp_你的github_token",
      "api": "openai-completions",
      "models": [
        {
          "id": "gpt-4o-mini",
          "name": "GPT-4o Mini",
          "contextWindow": 128000,
          "maxTokens": 4096
        }
      ]
    }
  }
}
```

### 使用硅基流动

```json
{
  "providers": {
    "siliconflow": {
      "baseUrl": "https://api.siliconflow.cn/v1",
      "apiKey": "sk-你的key",
      "api": "openai-completions",
      "models": [
        {
          "id": "deepseek-ai/DeepSeek-V3",
          "name": "DeepSeek V3",
          "contextWindow": 64000,
          "maxTokens": 8192
        }
      ]
    }
  }
}
```

---

## 推荐组合（已配置在 models-all-free.json 中）

我们提供了一个**全免费组合配置**，包含4个提供商：
- 联通云（5模型）
- Coze（Kimi K2.5）
- 硅基流动（DeepSeek + Qwen）
- GitHub Models（GPT-4o-mini + DeepSeek）

使用时，你只需要把对应的 API Key 填入即可，系统会自动切换可用的模型！
