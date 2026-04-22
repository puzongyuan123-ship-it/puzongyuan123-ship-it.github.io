<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>CYBER-ARCANA | 深度意识采样器</title>
    <style>
        :root {
            --bg: #050507;
            --accent: #00f3ff;
            --card-bg: rgba(20, 20, 25, 0.8);
            --text-main: #e0e0e0;
            --text-dim: #888;
            --font: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background-color: var(--bg);
            color: var(--text-main);
            font-family: var(--font);
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-image: 
                radial-gradient(circle at 50% 50%, #1a1a2e 0%, transparent 80%);
        }

        /* 扫描线背景效果 */
        body::before {
            content: "";
            position: absolute;
            width: 100%;
            height: 100%;
            background: linear-gradient(rgba(18, 16, 16, 0) 50%, rgba(0, 0, 0, 0.25) 50%), 
                        linear-gradient(90deg, rgba(255, 0, 0, 0.06), rgba(0, 255, 0, 0.02), rgba(0, 0, 255, 0.06));
            background-size: 100% 2px, 3px 100%;
            pointer-events: none;
            z-index: 10;
        }

        #app {
            width: 100%;
            max-width: 1200px;
            text-align: center;
            padding: 2rem;
            z-index: 1;
        }

        header {
            margin-bottom: 3rem;
            opacity: 0;
            animation: fadeIn 1.5s forwards;
        }

        h1 {
            font-weight: 200;
            letter-spacing: 0.5rem;
            font-size: 1.2rem;
            color: var(--accent);
            text-transform: uppercase;
        }

        .status-bar {
            font-size: 0.7rem;
            color: var(--text-dim);
            margin-top: 0.5rem;
        }

        /* 卡牌阵列 */
        .deck {
            display: flex;
            justify-content: center;
            gap: 20px;
            perspective: 1000px;
            height: 400px;
        }

        .card {
            width: 220px;
            height: 340px;
            background: var(--card-bg);
            border: 1px solid rgba(0, 243, 255, 0.2);
            border-radius: 4px;
            position: relative;
            cursor: pointer;
            transition: all 0.6s cubic-bezier(0.23, 1, 0.32, 1);
            transform-style: preserve-3d;
            box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        }

        .card:hover {
            transform: translateY(-20px) rotateY(10deg);
            border-color: var(--accent);
            box-shadow: 0 0 20px rgba(0, 243, 255, 0.3);
        }

        .card.flipped {
            transform: rotateY(180deg);
        }

        .card-front, .card-back {
            position: absolute;
            width: 100%;
            height: 100%;
            backface-visibility: hidden;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .card-back {
            background: linear-gradient(135deg, #0a0a0c 0%, #1a1a2e 100%);
            border: 1px solid rgba(0, 243, 255, 0.1);
        }

        .card-back::after {
            content: "NODE";
            font-size: 0.6rem;
            color: rgba(0, 243, 255, 0.2);
            letter-spacing: 4px;
        }

        .card-front {
            transform: rotateY(180deg);
            background: #0a0a0c;
        }

        .card-title {
            color: var(--accent);
            font-size: 1.1rem;
            margin-bottom: 1rem;
            font-weight: 300;
        }

        .card-desc {
            font-size: 0.85rem;
            line-height: 1.6;
            color: var(--text-dim);
            text-align: left;
        }

        /* 结果展示区 */
        #result-panel {
            position: fixed;
            bottom: 50px;
            left: 50%;
            transform: translateX(-50%);
            width: 80%;
            max-width: 800px;
            padding: 20px;
            border-top: 1px solid rgba(0, 243, 255, 0.3);
            display: none;
            animation: slideUp 0.8s ease-out;
        }

        .interpretation {
            font-size: 0.9rem;
            color: var(--text-main);
            line-height: 1.8;
            letter-spacing: 0.05rem;
        }

        /* 按钮设计 */
        .btn {
            background: transparent;
            border: 1px solid var(--accent);
            color: var(--accent);
            padding: 10px 30px;
            font-size: 0.8rem;
            cursor: pointer;
            letter-spacing: 2px;
            margin-top: 2rem;
            transition: 0.3s;
        }

        .btn:hover {
            background: var(--accent);
            color: var(--bg);
        }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes slideUp { from { transform: translate(-50%, 50px); opacity: 0; } to { transform: translate(-50%, 0); opacity: 1; } }

        /* 特效：能量流动 */
        .energy-line {
            position: absolute;
            background: var(--accent);
            box-shadow: 0 0 10px var(--accent);
        }

    </style>
</head>
<body>

<div id="app">
    <header>
        <h1 id="main-title">CONSCIOUSNESS SAMPLER v1.0.4</h1>
        <div class="status-bar" id="status-text">SYSTEM READY // 意识同步准备就绪...</div>
    </header>

    <div class="deck" id="card-container">
        </div>

    <div id="result-panel">
        <div class="interpretation" id="interpretation-text">
            点击卡牌以启动熵增分析序列...
        </div>
        <button class="btn" onclick="location.reload()">重新初始化</button>
    </div>
</div>

<script>
    const deckData = [
        { name: "0. 零位漂移 (愚者)", desc: "不稳定的初始状态。系统处于混沌边缘，所有的逻辑路径均未闭合。这意味着一种绝对的自由，以及对确定性的彻底背离。" },
        { name: "I. 协议载入 (魔术师)", desc: "意志作为底层指令开始干预现实。工具已齐备，接口已开放。当前节点具备重构环境的能力。" },
        { name: "II. 静态检索 (女祭司)", desc: "进入静默模式。非线性逻辑正在后台运行。不要试图从表象读取数据，真相隐藏在未被调用的注释行中。" },
        { name: "X. 循环冗余 (命运之轮)", desc: "系统的必然震荡。算法正在执行周期性回归。你认为的随机性，其实是更高维度的硬编码。" },
        { name: "XIII. 进程终结 (死神)", desc: "强制执行清道夫程序。旧有的内存地址被释放，不兼容的逻辑被抹除。这是系统优化的必要阵痛。" },
        { name: "XVI. 核心熔毁 (高塔)", desc: "不可预测的系统崩溃。架构本身存在缺陷，外力仅是诱因。在废墟之上，新的内核正在孕育。" },
        { name: "XVIII. 信号干扰 (月亮)", desc: "数据在传输中失真。直觉与逻辑发生冲突，感官溢出导致判断偏移。警惕幻觉生成的假象。" },
        { name: "XXI. 全域同步 (世界)", desc: "系统达到完美平衡。所有子程序逻辑自洽，闭环已完成。意识与物质层面的全协议打通。" }
    ];

    let selectedCards = [];
    const container = document.getElementById('card-container');
    const statusText = document.getElementById('status-text');
    const resultPanel = document.getElementById('result-panel');
    const interpText = document.getElementById('interpretation-text');

    // 初始化三张占位牌
    function init() {
        for (let i = 0; i < 3; i++) {
            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
                <div class="card-back"></div>
                <div class="card-front">
                    <div class="card-title">ANALYZING...</div>
                    <div class="card-desc"></div>
                </div>
            `;
            card.onclick = () => flipCard(card, i);
            container.appendChild(card);
        }
    }

    function flipCard(cardElement, index) {
        if (cardElement.classList.contains('flipped')) return;

        // 随机抽取一张牌（不重复）
        let randomIndex;
        do {
            randomIndex = Math.floor(Math.random() * deckData.length);
        } while (selectedCards.includes(randomIndex));
        
        selectedCards.push(randomIndex);
        const data = deckData[randomIndex];

        // 视觉反馈
        statusText.innerText = `SAMPLING DATA NODE ${index + 1}... [OK]`;
        
        const front = cardElement.querySelector('.card-front');
        front.querySelector('.card-title').innerText = data.name;
        front.querySelector('.card-desc').innerText = data.desc;
        
        cardElement.classList.add('flipped');

        if (selectedCards.length === 3) {
            showFinalResult();
        }
    }

    function showFinalResult() {
        setTimeout(() => {
            resultPanel.style.display = 'block';
            statusText.innerText = "SYNCHRONIZATION COMPLETE // 深度耦合分析完成";
            
            const titles = selectedCards.map(i => deckData[i].name.split(' ')[1]);
            interpText.innerHTML = `
                <strong>综合相位分析：</strong><br>
                当前意识流向正从 <u>${titles[0]}</u> 演化，经过 <u>${titles[1]}</u> 的逻辑过滤，最终将收敛于 <u>${titles[2]}</u> 态。<br>
                系统建议：摒弃冗余的情绪扰动，关注底层架构的重组。
            `;
        }, 800);
    }

    // 增加一些跟随鼠标的微妙光效
    document.addEventListener('mousemove', (e) => {
        const x = e.clientX / window.innerWidth;
        const y = e.clientY / window.innerHeight;
        document.body.style.backgroundImage = `
            radial-gradient(circle at ${x * 100}% ${y * 100}%, #1a1a2e 0%, #050507 80%)
        `;
    });

    init();
</script>

</body>
</html>
