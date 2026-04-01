/**
 * getDailyTasks - 获取每日学习任务（AI动态生成）
 * 云函数入口
 *
 * 依赖：腾讯云CloudBase + LLM API（如混元/Qwen/ChatGPT）
 *
 * 使用方式：
 *   const cloud = require('wx-server-sdk')
 *   cloud.init({ env: cloud.DYNAMIC_CURRENT_ENV })
 *
 *   exports.main = async (event, context) => {
 *     const { childId, grade, date } = event
 *     // 调用LLM API生成题目
 *     // 返回每日任务数据
 *   }
 */

const cloud = require('wx-server-sdk')

cloud.init({
  env: cloud.DYNAMIC_CURRENT_ENV
})

const db = cloud.database()

// TODO: 替换为你的LLM API配置
const LLM_CONFIG = {
  provider: 'tencent_hunyuan', // 或 'openai' / 'baidu_ernie'
  apiKey: process.env.LLM_API_KEY,
  model: 'hunyuan-pro'
}

async function generateDailyTasks(grade, subject, childLevel = 'normal') {
  /**
   * 调用 LLM API 生成每日练习题
   *
   * @param {string} grade - 幼儿园小班/中班/大班/一年级
   * @param {string} subject - 语文/数学/英语/思维/写字
   * @param {string} childLevel - 孩子的学习水平
   *
   * @returns {Array} 题目数组
   *
   * LLM Prompt 示例（中文幼教风格）：
   */
  const prompt = `
你是幼小衔接教育专家。请为${grade}的孩子生成5道${subject}练习题。
要求：
1. 题目适合3-7岁儿童
2. 难度适中，符合${grade}认知水平
3. 包含1-2道图片题（用emoji表示图片内容）
4. 答案唯一明确
5. 语言生动有趣

请以JSON数组格式返回，格式如下：
[{
  "type": "选择题/填空题/听力题/图片题",
  "content": "题目内容",
  "options": ["A选项", "B选项", "C选项", "D选项"],
  "correctAnswer": "正确答案",
  "points": 10,
  "explanation": "解题思路（可选）"
}]

请直接返回JSON数组，不要包含其他文字。
`

  // 实际调用时使用：
  // const response = await callLLM(prompt)
  // return JSON.parse(response)

  // 开发阶段返回Mock数据：
  return getMockQuestions(subject)
}

function getMockQuestions(subject) {
  const mockData = {
    '语文': [
      { type: '选择题', content: '哪个字是"日"字？', options: ['日', '目', '田', '白'], correctAnswer: '日', points: 10 },
      { type: '选择题', content: '"大"字有几笔？', options: ['2笔', '3笔', '4笔', '5笔'], correctAnswer: '3笔', points: 10 },
      { type: '填空题', content: '天上有个______(太阳)', options: ['太阳'], correctAnswer: '太阳', points: 10 },
      { type: '图片题', content: '图中是什么水果？', options: ['苹果', '香蕉', '橙子', '葡萄'], correctAnswer: '苹果', points: 10 },
      { type: '选择题', content: '"山"字像什么形状？', options: ['三角形', '圆形', '方形', '星形'], correctAnswer: '三角形', points: 10 }
    ],
    '数学': [
      { type: '选择题', content: '1 + 2 = ?', options: ['2', '3', '4', '5'], correctAnswer: '3', points: 10 },
      { type: '选择题', content: '5 - 1 = ?', options: ['3', '4', '5', '6'], correctAnswer: '4', points: 10 },
      { type: '选择题', content: '2 + 3 = ?', options: ['4', '5', '6', '7'], correctAnswer: '5', points: 10 },
      { type: '填空题', content: '比4多1是____', options: ['5'], correctAnswer: '5', points: 10 },
      { type: '图片题', content: '图中有几个苹果？', options: ['1个', '2个', '3个', '4个'], correctAnswer: '3个', points: 10 }
    ],
    '英语': [
      { type: '选择题', content: '苹果用英语怎么说？', options: ['Apple', 'Banana', 'Orange', 'Grape'], correctAnswer: 'Apple', points: 10 },
      { type: '选择题', content: '"Cat"是什么意思？', options: ['狗', '猫', '鸟', '鱼'], correctAnswer: '猫', points: 10 },
      { type: '选择题', content: '太阳用英语怎么说？', options: ['Moon', 'Star', 'Sun', 'Cloud'], correctAnswer: 'Sun', points: 10 },
      { type: '填空题', content: 'Hello! 你好！再见怎么说？', options: ['Goodbye'], correctAnswer: 'Goodbye', points: 10 },
      { type: '选择题', content: '"One"是数字几？', options: ['1', '2', '3', '4'], correctAnswer: '1', points: 10 }
    ],
    '思维': [
      { type: '选择题', content: '找规律：2, 4, 6, ___?', options: ['7', '8', '9', '10'], correctAnswer: '8', points: 10 },
      { type: '图片题', content: '哪两个图形是一样的？', options: ['第1和第3', '第2和第4', '第1和第2', '第3和第4'], correctAnswer: '第1和第3', points: 10 },
      { type: '选择题', content: '小明前面有3人，后面有2人，一共几人？', options: ['4人', '5人', '6人', '7人'], correctAnswer: '6人', points: 10 },
      { type: '选择题', content: '一个西瓜切3刀，最多能切几块？', options: ['4块', '6块', '7块', '8块'], correctAnswer: '8块', points: 10 },
      { type: '填空题', content: '○○ + ○○○ = ○○○○○? 正确吗？', options: ['正确', '错误'], correctAnswer: '正确', points: 10 }
    ],
    '写字': [
      { type: '选择题', content: '"一"字的笔画顺序第一步是？', options: ['横', '竖', '撇', '点'], correctAnswer: '横', points: 10 },
      { type: '选择题', content: '"人"字有几笔？', options: ['1笔', '2笔', '3笔', '4笔'], correctAnswer: '2笔', points: 10 },
      { type: '选择题', content: '"口"字像什么？', options: ['圆形', '方形', '三角形', '星形'], correctAnswer: '方形', points: 10 },
      { type: '填空题', content: '写"大"字时，先写____', options: ['横', '竖', '撇', '捺'], correctAnswer: '横', points: 10 },
      { type: '选择题', content: '握笔的正确姿势是？', options: ['捏紧', '轻握', '不用手', '用脚'], correctAnswer: '轻握', points: 10 }
    ]
  }

  return (mockData[subject] || mockData['语文']).map((q, index) => ({
    id: `${Date.now()}_${index}`,
    ...q
  }))
}

exports.main = async (event, context) => {
  const { childId, grade, date } = event

  try {
    // 从数据库获取孩子的学习历史（用于调整难度）
    const childDoc = await db.collection('children').doc(childId).get()
    const childLevel = childDoc?.data?.level || 'normal'

    // 科目列表
    const subjects = ['语文', '数学', '英语', '思维', '写字']

    // 为每个科目生成题目
    const courses = await Promise.all(
      subjects.map(async (subject) => {
        const questions = await generateDailyTasks(grade, subject, childLevel)
        return {
          id: `${Date.now()}_${subject}`,
          subject,
          title: subject,
          description: getSubjectDesc(subject),
          iconEmoji: getSubjectEmoji(subject),
          progress: 0,
          todayTasks: questions
        }
      })
    )

    return {
      success: true,
      data: {
        id: `${Date.now()}`,
        date: date || new Date().toISOString(),
        courses,
        totalMinutes: 30
      }
    }
  } catch (error) {
    return {
      success: false,
      error: error.message
    }
  }
}

function getSubjectDesc(subject) {
  const descs = {
    '语文': '识字/拼音/看图说话',
    '数学': '数数/口算/图形认知',
    '英语': '字母/单词/简单对话',
    '思维': '逻辑/观察/记忆力',
    '写字': '笔画/控笔/汉字描红'
  }
  return descs[subject] || ''
}

function getSubjectEmoji(subject) {
  const emojis = {
    '语文': '📖',
    '数学': '🔢',
    '英语': '🔤',
    '思维': '🧩',
    '写字': '✏️'
  }
  return emojis[subject] || '📚'
}
