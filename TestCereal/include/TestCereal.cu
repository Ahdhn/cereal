#include <assert.h>
#include <stdio.h>
#include <sstream>
#include <fstream>

#include "cereal/cereal.hpp"
#include"cereal/archives/binary.hpp"
#include "cereal/archives/json.hpp"

struct MyClass
{
    int x, y, z;

    template<class Archive>
    void serialize(Archive&archive)
    {
        archive(x, y, z);
    }
};


int main(int argc, char** argv)
{
    std::ofstream ss("MyClass.json");
   // cereal::BinaryOutputArchive archive(ss);
    cereal::JSONOutputArchive archive(ss);

    MyClass m1;
    m1.x = 1;
    m1.y = 99;
    m1.z = 77;
    archive(CEREAL_NVP(m1));

    return 0;
}
