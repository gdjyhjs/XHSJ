using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;

//延迟数据
public abstract class TimerCoroutine {
    private System.Action call;

    public bool isStop { get; private set; }
    public bool loop { get; protected set; }

    //停止
    public virtual void Stop() {
        isStop = true;
    }

    //初始化
    protected void Init(Action call, bool loop) {
        this.call = call;
        this.loop = loop;
    }

    //运行
    protected void Run() {
        if (isStop) {
            return;
        }

        call?.Invoke();

        if (!loop) {
            isStop = true;
        }
    }
}

public class TimerMgr : MonoBehaviour {
    //定时器基类
    private abstract class CoroutineBase : TimerCoroutine {
        //初始化
        new public void Init(Action call, bool loop) {
            base.Init(call, loop);
        }

        //刷新
        public abstract void Update();
    }

    //时间延迟，受缩放影响
    private class CoroutineTime : CoroutineBase {
        public float time { get; private set; }
        public float createTime { get; private set; }

        public void InitTime(float time) {
            this.time = time;
            this.createTime = UnityEngine.Time.time;
        }

        //刷新
        public override void Update() {
            if (UnityEngine.Time.time - createTime >= time) {
                Run();
                createTime = UnityEngine.Time.time;
            }
        }
    }

    //固定时间延迟，不受缩放影响
    private class CoroutineUntime : CoroutineBase {
        public float time { get; private set; }
        public float createUnscaledTime { get; private set; }

        public void InitUntime(float time) {
            this.time = time;
            this.createUnscaledTime = UnityEngine.Time.unscaledTime;
        }

        //刷新
        public override void Update() {
            if (UnityEngine.Time.unscaledTime - createUnscaledTime >= time) {
                Run();
                createUnscaledTime = UnityEngine.Time.unscaledTime;
            }
        }
    }

    //固定帧率调用，受缩放影响
    private class CoroutineFrame : CoroutineBase {
        public int frame { get; private set; }
        public int createFrame { get; private set; }

        public void InitFrame(int frame) {
            this.frame = frame;
            this.createFrame = UnityEngine.Time.frameCount;
        }

        //刷新
        public override void Update() {
            if (UnityEngine.Time.frameCount - createFrame >= frame) {
                Run();
                createFrame = UnityEngine.Time.frameCount;
            }
        }
    }

    //固定帧率调用，不受缩放影响
    private class CoroutineUnframe : CoroutineBase {
        public int frame { get; private set; }
        public int createFrame { get; private set; }

        public void InitUnframe(int frame) {
            this.frame = frame;
            this.createFrame = UnityEngine.Time.frameCount;
        }

        //刷新
        public override void Update() {
            if (UnityEngine.Time.frameCount - createFrame >= frame) {
                Run();
            }
        }
    }

    private bool isDestroy;

    private Dictionary<int, CoroutineTime> allTime = new Dictionary<int, CoroutineTime>();
    private Dictionary<int, CoroutineUntime> allUntime = new Dictionary<int, CoroutineUntime>();
    private Dictionary<int, CoroutineFrame> allFrame = new Dictionary<int, CoroutineFrame>();
    private Dictionary<int, CoroutineUnframe> allUnframe = new Dictionary<int, CoroutineUnframe>();

    public void Init(System.Action call) {
        call();
    }

    //延时时间刷新
    private void Update() {
        UpdateTime(allTime);
        UpdateTime(allUntime);
        UpdateTime(allFrame);
        UpdateTime(allUnframe);
    }

    //刷新一个组
    private void UpdateTime<T>(Dictionary<int, T> times) where T : CoroutineBase {
        List<int> delKey = new List<int>();
        int[] allKey = new int[times.Keys.Count];
        int index = 0;
        foreach (var item in times.Keys) {
            allKey[index] = item;
            index++;
        }
        for (int i = 0; i < allKey.Length; i++) {
            T item = null;
            times.TryGetValue(allKey[i], out item);
            if (item == null) {
                continue;
            }

            item.Update();
            if (item.isStop) {
                delKey.Add(allKey[i]);
            }
        }
        for (int i = 0; i < delKey.Count; i++) {
            times.Remove(delKey[i]);
        }
    }

    //停止携程
    public void Stop(TimerCoroutine cor) {
        if (cor != null) {
            cor.Stop();
        }
    }

    //停止所有携程
    public void Destroy() {
        isDestroy = true;

        allFrame.Clear();
        allUnframe.Clear();
        allTime.Clear();
        allUntime.Clear();
    }

    //延时时间执行一个携程
    public TimerCoroutine Time(Action call, float time, bool loop = false) {
        if (isDestroy) {
            return null;
        }
        if (time <= 0) {
            call();
            if (!loop) {
                return null;
            }
        }

        CoroutineTime coroutineTime = new CoroutineTime();
        coroutineTime.Init(call, loop);
        coroutineTime.InitTime(time);
        allTime[coroutineTime.GetHashCode()] = coroutineTime;

        return coroutineTime;
    }

    //延时时间执行一个携程
    public TimerCoroutine Untime(Action call, float time, bool loop = false) {
        if (isDestroy) {
            return null;
        }
        if (time <= 0) {
            call();
            if (!loop) {
                return null;
            }
        }

        CoroutineUntime coroutineUntime = new CoroutineUntime();
        coroutineUntime.Init(call, loop);
        coroutineUntime.InitUntime(time);
        allUntime[coroutineUntime.GetHashCode()] = coroutineUntime;

        return coroutineUntime;
    }

    //延时帧率执行一个携程
    public TimerCoroutine Frame(Action call, int frame, bool loop = false) {
        if (isDestroy) {
            return null;
        }
        if (frame <= 0) {
            call();
            if (!loop) {
                return null;
            }
        }

        CoroutineFrame coroutineFrame = new CoroutineFrame();
        coroutineFrame.Init(call, loop);
        coroutineFrame.InitFrame(frame);
        allFrame[coroutineFrame.GetHashCode()] = coroutineFrame;

        return coroutineFrame;
    }

    //延时帧率执行一个携程
    public TimerCoroutine Unframe(Action call, int frame, bool loop = false) {
        if (isDestroy) {
            return null;
        }
        if (frame <= 0) {
            call();
            if (!loop) {
                return null;
            }
        }

        CoroutineUnframe coroutineUnframe = new CoroutineUnframe();
        coroutineUnframe.Init(call, loop);
        coroutineUnframe.InitUnframe(frame);
        allUnframe[coroutineUnframe.GetHashCode()] = coroutineUnframe;

        return coroutineUnframe;
    }

    //延时一个对象
    public Coroutine Yield(Action call, YieldInstruction yie) {
        if (isDestroy) {
            return null;
        }
        return StartCoroutine(IYield(call, yie));
    }
    private IEnumerator IYield(Action call, YieldInstruction yie) {
        yield return yie;
        call();
    }

    //开启一个线程
    public void Thread(Action call, Action onComplete = null) {
        bool isComplete = false;
        TimerCoroutine cor = null;
        cor = g.timer.Frame(() => {
            if (isComplete) {
                g.timer.Stop(cor);
                g.timer.Frame(() => {
                    if (onComplete != null) {
                        onComplete();
                    }
                }, 1);
                return;
            }
        }, 1, true);

        if (GameConf.isThread) {
            Thread th = new Thread(new ThreadStart(() => {
                try {
                    call();
                    isComplete = true;
                    System.Threading.Thread.Sleep(1000);
                } catch (Exception) {
                    isComplete = true;
                    throw;
                }
            }));
            th.IsBackground = true;
            th.Start();
        } else {
            call();
            isComplete = true;
        }
    }
}
