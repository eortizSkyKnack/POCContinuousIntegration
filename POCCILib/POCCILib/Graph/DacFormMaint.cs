using System;
using PX.Data;
using PX.Data.BQL.Fluent;

namespace POCCI
{
    public class DacFormMaint : PXGraph<DacFormMaint, CustomDacForm>
    {
        public SelectFrom<CustomDacForm>.View MasterView;

        public static void test()
        {
            
        }
    }
}