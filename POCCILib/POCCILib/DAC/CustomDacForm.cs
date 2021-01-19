using System;
using PX.Data;

namespace POCCI
{
    [Serializable]
    [PXCacheName("CustomDacForm")]
    public class CustomDacForm : IBqlTable
    {
        #region Id

        public abstract class id : PX.Data.BQL.BqlString.Field<id>
        {
        }

        [PXDBString(length: 255, IsKey = true, IsUnicode = true)]
        [PXUIField(DisplayName = "ID", Enabled = true)]
        public virtual string Id { get; set; }

        #endregion

        #region Name

        public abstract class name : PX.Data.BQL.BqlString.Field<name>
        {
        }

        [PXDBString(length: 40, IsUnicode = true)]
        [PXUIField(DisplayName = "Name", Enabled = true)]
        public virtual string Name { get; set; }

        #endregion

        #region CreatedByID

        public abstract class createdByID : PX.Data.BQL.BqlGuid.Field<createdByID>
        {
        }

        [PXDBCreatedByID()] public virtual Guid? CreatedByID { get; set; }

        #endregion

        #region CreatedByScreenID

        public abstract class createdByScreenID : PX.Data.BQL.BqlString.Field<createdByScreenID>
        {
        }

        [PXDBCreatedByScreenID()] public virtual string CreatedByScreenID { get; set; }

        #endregion

        #region CreatedDateTime

        public abstract class createdDateTime : PX.Data.BQL.BqlDateTime.Field<createdDateTime>
        {
        }

        [PXDBCreatedDateTime()] public virtual DateTime? CreatedDateTime { get; set; }

        #endregion

        #region LastModifiedByID

        public abstract class lastModifiedByID : PX.Data.BQL.BqlGuid.Field<lastModifiedByID>
        {
        }

        [PXDBLastModifiedByID()] public virtual Guid? LastModifiedByID { get; set; }

        #endregion

        #region LastModifiedByScreenID

        public abstract class lastModifiedByScreenID : PX.Data.BQL.BqlString.Field<lastModifiedByScreenID>
        {
        }

        [PXDBLastModifiedByScreenID()] public virtual string LastModifiedByScreenID { get; set; }

        #endregion

        #region LastModifiedDateTime

        public abstract class lastModifiedDateTime : PX.Data.BQL.BqlDateTime.Field<lastModifiedDateTime>
        {
        }

        [PXDBLastModifiedDateTime()] public virtual DateTime? LastModifiedDateTime { get; set; }

        #endregion

        #region Tstamp

        public abstract class tstamp : PX.Data.BQL.BqlByteArray.Field<tstamp>
        {
        }

        [PXDBTimestamp()]
        [PXUIField(DisplayName = "Tstamp")]
        public virtual byte[] Tstamp { get; set; }

        #endregion
    }
}