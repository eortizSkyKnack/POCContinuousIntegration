using PX.Data;

namespace POCCI
{
    public class AddressExt : PXCacheExtension<PX.Objects.CR.Address>
    {
        #region UsrCustomAddresssField

        [PXDBString(30)]
        [PXUIField(DisplayName = "Custom Address Field")]

        public virtual string UsrCustomAddresssField { get; set; }

        public abstract class usrCustomAddresssField : PX.Data.BQL.BqlString.Field<usrCustomAddresssField>
        {
        }

        #endregion
    }
}