using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour {
    public static SoundManager instance;
    private void Awake() {
        if (instance == null) {
            instance = this;
            music.loop = true;
            var v = SettingData.instance; // 初始化声音设置
            SetMusic(MusicClipType.bg_3);
            music.Play();
        }
    }

    public AudioSource music;
    public AudioSource sound_effect;

    public AudioClip[] bg_music;
    public AudioClip[] ui_clip;

    public static void SetVolume() {
        SettingData data = SettingData.instance;
        instance.music.volume = data.volume * data.music / 10000f;
        instance.sound_effect.volume = data.volume * data.sound_effect / 10000f;
    }

    public static void SetRandomMusic(MusicClipType min = MusicClipType.bg_1, MusicClipType max = MusicClipType.end) {
        SetMusic((MusicClipType)Random.Range((int)min, (int)max));
    }
    public static void SetMusic(MusicClipType bg) {
        instance.music.clip = instance.bg_music[(int)bg];
    }

    bool uimute = true;
    public static void PlayUIClip(UIClipType bg) {
        if (instance.uimute)
            return;
        instance.sound_effect.PlayOneShot(instance.ui_clip[(int)bg]);
    }
    public static void SetUIMute(bool isOn = false) {
        instance.uimute = isOn;
    }


    public enum MusicClipType {
        /// <summary>
        /// 门派
        /// </summary>
        bg_1,
        /// <summary>
        /// 秘境
        /// </summary>
        bg_2,
        /// <summary>
        /// 城市3
        /// </summary>
        bg_3,
        /// <summary>
        /// 城市4
        /// </summary>
        bg_4,
        /// <summary>
        /// 战斗5
        /// </summary>
        bg_5,
        /// <summary>
        /// 战斗6
        /// </summary>
        bg_6,
        /// <summary>
        /// 战斗7
        /// </summary>
        bg_7,
        /// <summary>
        /// 野外8
        /// </summary>
        bg_8,
        /// <summary>
        /// 野外9
        /// </summary>
        bg_9,


        end,
    }


    public enum UIClipType {
        /// <summary>
        /// 打开背包
        /// </summary>
        bag_open,
        /// <summary>
        /// 勇气 信心 buff
        /// </summary>
        bottle,
        /// <summary>
        /// 买东西
        /// </summary>
        button_buy,
        /// <summary>
        /// 按钮切换
        /// </summary>
        button_change,
        /// <summary>
        /// 关闭按钮
        /// </summary>
        button_close,
        /// <summary>
        /// 按钮通用点击
        /// </summary>
        button_common,
        /// <summary>
        /// 按钮进入
        /// </summary>
        button_in,
        /// <summary>
        /// 钱币声音
        /// </summary>
        coin,
        /// <summary>
        /// 命运 噗的一声
        /// </summary>
        destiny,
        /// <summary>
        /// 锻造
        /// </summary>
        duanzao,
        /// <summary>
        /// 装备
        /// </summary>
        equip,
        /// <summary>
        /// 合成
        /// </summary>
        hecheng,
        /// <summary>
        /// 新的消息
        /// </summary>
        new_message,
        /// <summary>
        /// 整理背包
        /// </summary>
        stuff_bag,
        /// <summary>
        /// 解锁
        /// </summary>
        unlock = 14,
    }
}
