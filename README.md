<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>K-POP SPECTRA | 3D ARCHIVE</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@900&family=Playfair+Display:ital@1&display=swap');
        body { margin: 0; background: #000; color: #fff; overflow-x: hidden; font-family: 'Inter', sans-serif; }
        canvas { position: fixed; top: 0; left: 0; z-index: -1; }
        
        .glass {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
        }

        section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 0 10%;
            pointer-events: none; /* 让触摸穿透到背景的 3D 引擎 */
        }

        .content-box { pointer-events: auto; }
        
        .highlight { color: #ff0055; text-shadow: 0 0 20px rgba(255, 0, 85, 0.5); }

        /* 隐藏滚动条 */
        ::-webkit-scrollbar { display: none; }
    </style>
</head>
<body>

    <canvas id="bg-canvas"></canvas>

    <main>
        <section>
            <div class="content-box">
                <h2 class="text-zinc-500 tracking-[0.8em] text-xs mb-4 uppercase">Archive v1.0</h2>
                <h1 class="text-7xl font-black italic tracking-tighter leading-none mb-6">
                    K-POP<br><span class="text-transparent" style="-webkit-text-stroke: 1px rgba(255,255,255,0.5);">SPECTRA</span>
                </h1>
                <p class="text-zinc-400 max-w-sm text-xs leading-relaxed font-light uppercase tracking-widest">
                    一个关于审美、逻辑与工业化偶像进化的 3D 叙事空间。
                </p>
            </div>
        </section>

        <section>
            <div class="content-box glass p-10 max-w-xl">
                <div class="text-pink-500 font-mono text-xs mb-4">// 01_THE_ORIGIN</div>
                <h2 class="text-4xl font-bold mb-4">开创：汉江的脉动</h2>
                <p class="text-zinc-300 leading-loose text-sm">
                    1992 年，《Seo Taiji and Boys》在电视荧幕上投下的震撼，宣告了传统歌谣时代的终结。SM 娱乐随后建立的“全产业链练习生体系”，将偶像从“职业”变成了“工业化精密产品”。
                </p>
                <div class="mt-6 flex gap-4 text-[10px] font-mono text-zinc-500">
                    <span>H.O.T</span> <span>S.E.S</span> <span>SHINHWA</span>
                </div>
            </div>
        </section>

        <section class="justify-end">
            <div class="content-box glass p-10 max-w-xl text-right">
                <div class="text-blue-400 font-mono text-xs mb-4">// 02_GOLDEN_ERA</div>
                <h2 class="text-4xl font-bold mb-4">盛世：亚洲秩序</h2>
                <p class="text-zinc-300 leading-loose text-sm">
                    东方神起在东京巨蛋的泪水，少女时代《Gee》的病毒式旋律。这个时代，K-pop 掌握了名为“Hooks”的逻辑武器。BIGBANG 则赋予了偶像“创作者”的尊严。
                </p>
                <div class="mt-6 flex gap-4 justify-end text-[10px] font-mono text-zinc-500">
                    <span>TVXQ</span> <span>BIGBANG</span> <span>SNSD</span> <span>2NE1</span>
                </div>
            </div>
        </section>

        <section>
            <div class="content-box">
                <h2 class="text-6xl font-black mb-8 highlight">LIMITLESS.</h2>
                <p class="text-zinc-500 max-w-md italic tracking-wide">
                    从 BTS 的社交媒体神话，到 aespa 的虚拟化身。K-pop 正在变成一种超越国界的“数字宗教”。
                </p>
            </div>
        </section>
    </main>

    <script type="module">
        import * as THREE from 'https://cdn.skypack.dev/three@0.136.0';

        let scene, camera, renderer, particles;
        let mouseX = 0, mouseY = 0;

        const init = () => {
            scene = new THREE.Scene();
            camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 2000);
            camera.position.z = 800;

            renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('bg-canvas'), antialias: true });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setPixelRatio(window.devicePixelRatio);

            // 核心 3D 逻辑：构建一个流动的粒子星云
            const geometry = new THREE.BufferGeometry();
            const pos = [];
            const cols = [];
            for(let i=0; i<15000; i++) {
                pos.push((Math.random()-0.5)*2000, (Math.random()-0.5)*2000, (Math.random()-0.5)*2000);
                const color = new THREE.Color();
                color.setHSL(Math.random() * 0.2 + 0.8, 0.8, 0.5); // 偏紫色调
                cols.push(color.r, color.g, color.b);
            }
            geometry.setAttribute('position', new THREE.Float32BufferAttribute(pos, 3));
            geometry.setAttribute('color', new THREE.Float32BufferAttribute(cols, 3));

            const material = new THREE.PointsMaterial({
                size: 2, 
                vertexColors: true, 
                blending: THREE.AdditiveBlending, 
                transparent: true,
                opacity: 0.6 
            });

            particles = new THREE.Points(geometry, material);
            scene.add(particles);

            animate();
        };

        const animate = () => {
            requestAnimationFrame(animate);
            // 摄像机视差随滚动与鼠标移动同步
            const scrollY = window.scrollY;
            particles.rotation.y += 0.001;
            particles.rotation.x = scrollY * 0.0005;
            
            camera.position.x += (mouseX - camera.position.x) * 0.05;
            camera.position.y += (-mouseY - camera.position.y) * 0.05;
            camera.lookAt(scene.position);

            renderer.render(scene, camera);
        };

        window.addEventListener('mousemove', e => {
            mouseX = (e.clientX - window.innerWidth/2) * 0.5;
            mouseY = (e.clientY - window.innerHeight/2) * 0.5;
        });

        window.addEventListener('touchmove', e => {
            mouseX = (e.touches[0].clientX - window.innerWidth/2) * 0.5;
            mouseY = (e.touches[0].clientY - window.innerHeight/2) * 0.5;
        }, { passive: false });

        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
        });

        init();
    </script>
</body>
</html>
