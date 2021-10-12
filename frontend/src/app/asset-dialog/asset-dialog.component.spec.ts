import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AssetDialogComponent } from './asset-dialog.component';

describe('AssetDialogComponent', () => {
  let component: AssetDialogComponent;
  let fixture: ComponentFixture<AssetDialogComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AssetDialogComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AssetDialogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
