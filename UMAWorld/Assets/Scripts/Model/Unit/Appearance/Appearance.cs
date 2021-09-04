using System.Collections;
using System.Collections.Generic;


namespace UMAWorld {
    // 外观json
    public class Appearance {
        public enum Sex {
            Man,
            Woman,
        }
        public enum Race {
            Human,
            Elf,
        }
        public string umaData;
        public string name;
        public Sex sex;
        public Race race;
    }
}