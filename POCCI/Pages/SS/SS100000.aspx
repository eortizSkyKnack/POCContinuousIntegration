<%@ Page Language="C#" MasterPageFile="~/MasterPages/FormView.master" AutoEventWireup="true" ValidateRequest="false" CodeFile="SS100000.aspx.cs" Inherits="Page_SS100000" Title="Untitled Page" %>
<%@ MasterType VirtualPath="~/MasterPages/FormView.master" %>

<asp:Content ID="cont1" ContentPlaceHolderID="phDS" Runat="Server">
    <px:PXDataSource ID="ds" runat="server" Visible="True" Width="100%"
                     TypeName="POCCI.DacFormMaint"
                     PrimaryView="MasterView">
        <CallbackCommands>

        </CallbackCommands>
    </px:PXDataSource>
</asp:Content>
<asp:Content ID="cont2" ContentPlaceHolderID="phF" Runat="Server">
    <px:PXFormView ID="form" runat="server" DataSourceID="ds" DataMember="MasterView" Width="100%" AllowAutoHide="false">
        <Template>
            <px:PXLayoutRule ID="PXLayoutRule1" runat="server" StartRow="True"></px:PXLayoutRule>
            <px:PXMaskEdit runat="server" ID="CstPXMaskEdit1" DataField="Id"></px:PXMaskEdit>
            <px:PXTextEdit runat="server" ID="CstPXTextEdit2" DataField="Name"></px:PXTextEdit>
        </Template> <AutoSize Container="Window" Enabled="True" MinHeight="200"/>
    </px:PXFormView>
</asp:Content>