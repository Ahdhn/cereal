#include <assert.h>
#include <stdio.h>
#include <fstream>
#include <sstream>
#include <vector>

#include "gtest/gtest.h"

#include <cereal/types/vector.hpp>
#include "cereal/archives/binary.hpp"
#include "cereal/archives/json.hpp"
#include "cereal/cereal.hpp"

struct MyClass
{
    int              x, y, z;
    std::vector<int> v;

    template <class Archive>
    void serialize(Archive& archive)
    {
        archive(CEREAL_NVP(x), CEREAL_NVP(y), CEREAL_NVP(z), CEREAL_NVP(v));
    }
};

TEST(Test, cereal)
{
    std::string filename = "MyClass.json";
    int         x_val    = 1;
    int         y_val    = 99;
    int         z_val    = 77;
    int         vec_val  = 88;
    size_t      vec_size = 10;

    {
        std::ofstream ss(filename);
        // cereal::BinaryOutputArchive archive(ss);
        cereal::JSONOutputArchive archive(ss);

        MyClass m1;
        m1.x = x_val;
        m1.y = y_val;
        m1.z = z_val;
        m1.v.resize(vec_size, vec_val);

        archive(CEREAL_NVP(m1));
    }

    {
        std::ifstream is(filename);

        cereal::JSONInputArchive archive(is);

        MyClass m1;
        archive(m1);

        EXPECT_EQ(m1.x, x_val);
        EXPECT_EQ(m1.y, y_val);
        EXPECT_EQ(m1.z, z_val);
        EXPECT_EQ(m1.v.size(), vec_size);

        for (size_t i = 0; i < m1.v.size(); ++i) {
            EXPECT_EQ(m1.v[i], vec_val);
        }
    }
}

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
