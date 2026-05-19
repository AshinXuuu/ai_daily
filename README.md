# 信号 / Signal · 部署指南

让团队 5 分钟内打开日报链接的最快路径。

---

## 🎯 你将得到

部署完成后，你和团队会拿到一个**永久链接**，例如：
```
https://project-wycff.vercel.app/
```
打开链接 → 看到所有日报的索引页 → 点任意一期阅读全文。

---

## 📦 这个文件夹里有什么

```
signal-site/
├── index.html              ← 首页（日报档案柜）
├── daily/                  ← 历史日报，按日期命名
│   ├── ai_daily_2026_04_23.html
│   ├── ai_daily_2026_04_24.html
│   └── ...
├── README.md               ← 你正在看的这份文件
└── 部署指南.md              ← 详细部署步骤
```

---

## 🚀 部署步骤（首次配置 · 5 分钟）

### 第 1 步 · 注册 Vercel（30 秒）

1. 打开 [vercel.com](https://vercel.com)
2. 点 **"Sign Up"** → 选 **"Continue with GitHub"**
3. 如果没有 GitHub 账号，先去 [github.com](https://github.com) 注册一个（用邮箱 1 分钟搞定）

### 第 2 步 · 上传文件（2 分钟）

**最快的方式 — 拖拽部署，不需要懂 Git：**

1. 登录 Vercel 后，点首页右上角 **"Add New..."** → **"Project"**
2. 滚动到底部找到 **"Deploy a template"** 区域，点旁边的 **"Browse"**
   - 或者直接在 Vercel 首页找 **"Deploy"** → **"Browse all templates"**

**更简单的方式 — 直接拖拽：**

1. 登录 Vercel 后访问 [vercel.com/new](https://vercel.com/new)
2. 找到 **"Import Third-Party Git Repository"** 下方的小字 — 或者搜 "drag and drop"
3. 把整个 `signal-site` 文件夹**直接拖**进 Vercel 网页
4. 点 **Deploy**

> 💡 如果拖拽不可用，走 GitHub 方式：先在 GitHub 新建一个仓库，把这些文件全部上传，然后在 Vercel 里 "Import Git Repository" 选这个仓库。

### 第 3 步 · 拿到链接（30 秒）

部署成功后，Vercel 会显示一个网址，例如：
```
https://signal-site-xxxxx.vercel.app
```

把这个链接复制给团队群 — 他们打开就能看 ✅

---

## 🔄 之后每天怎么更新

### 方式 A · 网页拖拽（最简单）

1. 把今天 Claude 给你的 HTML 文件放进 `daily/` 文件夹
2. 编辑 `index.html`，复制一个旧的 `<a class="issue">...</a>` 块，改成新一期的信息
3. 重新拖拽整个 `signal-site` 文件夹到 Vercel

### 方式 B · 用 GitHub（推荐 · 自动同步）

如果你走 GitHub 路线，**只需要把新文件上传到 GitHub 仓库**：
1. 打开你的仓库网页
2. 进 `daily/` 文件夹
3. 点 **"Add file"** → **"Upload files"** → 把今天的 HTML 拖进去 → Commit
4. 编辑 `index.html` 加一行链接 → Commit
5. 30 秒后 Vercel 自动更新网站，无需手动操作

---

## ❓ 常见问题

**Q: 团队同事打开慢怎么办？**
A: Vercel 国内访问速度一般在 1-3 秒，绝大多数情况下够用。如果有用户反馈慢，可以考虑 Vercel Pro（$20/月）开启亚太节点，或换成腾讯云 / 阿里云方案。

**Q: 怕日报内容外泄怎么办？**
A: Vercel 免费版默认是公开链接（任何人有链接就能看）。三种保护选项：
- **简单版**：链接不要发到公开渠道，仅内部群分享 — 链接很难被陌生人猜到
- **标准版**：升级 Vercel Pro，开启 "Password Protection"（每月 20 美元）
- **企业版**：用腾讯云 OSS / 阿里云 OSS + IP 白名单（每月几块钱）

**Q: 网址太丑想要自己的域名？**
A: Vercel 设置里可以绑定自定义域名（例如 `signal.yourcompany.com`），免费支持 HTTPS。在阿里云 / 腾讯云买个域名（一年几十块）即可。

**Q: 我不会 Git 怎么办？**
A: 完全不用懂 Git。直接用 GitHub 网页版的"上传文件"按钮，跟用网盘一样。

---

## 📋 给团队同事的"使用须知"

可以把下面这段话直接发到团队群：

> 📰 **AI 日报内部档案** · https://[你的链接].vercel.app
>
> 每天 / 每周更新一份 AI 行业速读，6 大主题（大模型 / 资本 / 监管 / 具身智能 / 硬件 / 数据）。
>
> 👀 **怎么用** — 收藏链接，随时打开
> 🔍 **怎么检索** — Ctrl+F 搜关键词，每条都有原文链接
> 💬 **有反馈** — 直接 @ 我

---

## 🎨 想换风格 / 添加新功能？

如果想要：
- 加搜索框（按关键词搜历史日报）
- 加标签筛选（只看"具身智能"相关）
- 加 RSS 订阅（同事用阅读器订阅）
- 加邮件推送（每天自动发到团队邮箱）

回到 Claude 直接说"帮我加 XXX 功能"就行。

---

最后一件事：**第一次部署成功后，把链接发给我**，我可以帮你做一个测试 + 给你团队同事写一份"打开链接看日报"的 1 分钟新人引导。
