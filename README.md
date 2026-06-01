# 道德与法治命题工具包

初中道德与法治（7-8年级）试题命制全套工具——AI 辅助命题、情景搜索、规范检验、试题库管理。

## 包含技能

| 技能 | 功能 | 触发方式 |
|------|------|---------|
| **objective-question** | 客观题（选择题）命制 | "命制选择题""出几道客观题" |
| **subjective-question** | 主观题（材料分析/情境探究）命制 | "命制主观题""出材料题" |
| **scenario-judgment** | 情景核心知识判断题 | "出判断题""情景判断" |
| **question-bank-manager** | 试题入库自动归类 | "存题""入库" |

## 试题库结构

```
memory/question-bank/
├── 选择题/           # 16道（七年级下册）
│   ├── 七年级上册/   (13课)
│   ├── 七年级下册/   (11课)
│   ├── 八年级上册/   (12课)
│   └── 八年级下册/   (12课)
├── 材料题/           # 8道（七下4 + 八上4）
│   └── ...
└── (九年级待补充)
```

## 快速安装

### 方式一：一键脚本
```bash
git clone https://github.com/liwvken/dao-de-jiaoti-proposition.git
cd dao-de-jiaoti-proposition
bash setup.sh
```

### 方式二：作为 Claude Code 插件安装
```bash
claude plugin marketplace add liwvken/dao-de-jiaoti-proposition
claude plugin install dao-de-jiaoti-proposition@dao-de-jiaoti-proposition
```

安装后重启 Claude Code 或运行 `/reload-plugins`。

## 命题流程

### 客观题命制（8步）
确认需求 → 确定考点 → **情景选择（询问有无现成素材）** → 题干设计 → 设问设计 → 选项设计（4选项+干扰项类型标注） → **完整审题检验（政治性/科学性/逻辑性/规范性/公平性）** → 配套输出

### 主观题命制（7步）
确认需求 → 确定立意 → **情景选择** → 设问设计（以"结合材料"开头） → 答案与评分标准（分层赋分） → **完整审题检验** → 配套输出

### 情景判断题（6步）
确认需求 → **情景选择** → 知识点嵌入设计 → 题干设计 → **完整审题检验** → 配套输出

## 核心规范

- **命题总要求**：`memory/proposition-general-requirements.md`（命题依据、目标、原则、规划、学业质量、逻辑规范）
- **教材框架**：`memory/textbook-7a.md` ~ `textbook-8b.md` + `textbook-xi-reader.md`
- **素材搜索范围**：人民网、新华网、教育部官网、中国普法网等权威渠道，近6个月

## 适用对象

初中道德与法治一线教师、命题组成员、教研员。

## 许可

MIT
