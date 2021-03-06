/*
   Copyright 2012 Eliot van Uytfanghe

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
class FColumnsSet extends FMultiComponent;

var(Component, Display) int NumColumns;
var(Component, Display) int NumRows;

var(Component, Function) class<FColumn> ColumnClass;

var(Component, Advanced) protectedwrite editinline array<FColumn> Columns;

var protectedwrite editinline transient FColumn SelectedColumn;

delegate OnSelect( FColumn sender );

function Free()
{
	super.Free();
	Columns.Length = 0;
	SelectedColumn = none;
	OnSelect = none;
}

function InitializeComponent()
{
	local int i, j;
	local float columnSizeX, columnSizeY;
	local float pX, pY;
	local FColumn comp;
	
	super.InitializeComponent();
	
	columnSizeX = RelativeSize.X/NumColumns;
	columnSizeY = RelativeSize.Y/NumRows;
	pY = 0.0;
	for( i = 0; i < NumRows; ++ i )
	{
		pX = 0;
		for( j = 0; j < NumColumns; ++ j )
		{
			comp = FColumn(CreateComponent( ColumnClass, self ));
			comp.SetPos( pX, pY );
			comp.SetSize( columnSizeX, columnSizeY );
			comp.OnClick = Select;
			AddComponent( comp );
			Columns.AddItem( comp );
			
			pX += columnSizeX;
		}
		pY += columnSizeY;
	}
}

protected function Select( FComponent sender, optional bool bRight )
{
	SelectedColumn = FColumn(sender);
	OnSelect( SelectedColumn );	
}

function RenderComponent( Canvas C )
{
	super.RenderComponent( C );
	RenderBackground( C );
}

defaultproperties
{
	NumColumns=3
	NumRows=3
	ColumnClass=class'FColumn'
	
	bSupportSelection=false
	bSupportHovering=false
}